# Discussion
#
# We need to detect whether or not the underlying Hash or Array changed and
# update the dirty-ness of the encapsulating Resource accordingly (so that it
# will actually save).
#
# DM's state-tracking code only triggers dirty-ness by comparing a new value
# against the existing instance's property's value.  This means that we always
# have to mutate a *new* value instead of self -- if we mutated self, then that
# dirty-ness comparison would always be equivalent (self vs. self) and the
# resource would never save the changed values.
#
# This means we have to operate on a clone first, determine if self and mutated
# are different, and conditionally set the Resource's attribute with the known
# different value.  This might sound expensive, but it's actually identical to
# what you already had to do: assign a cloned copy in order to trigger
# dirty-ness.  ::DataMapper::Property::Json example:
#
#     model.json = model.json.merge({:some=>:value})
#
# Approach
#
# We want to hook certain methods on Hash and Array to trigger dirty-ness in the
# resource.  Because these are core classes, they are individually mapped to C
# primitives and thus cannot be hooked through #send/#__send__.  We have to
# override each method, but we don't want to write a lot of code.
#
# We also want to extend behaviour of existing class instances instead of
# impersonating/delegating from a proxy class of our own, or overriding a global
# class behaviour.  This is the most flexible approach and least prone to error,
# since it leaves open the option for consumers to proxy or override global
# classes, and is less likely to interfere with method_missing/etc shenanigans.
#
# However, because of how DM dirty-ness tracking works, we have to conduct
# mutation operations on clones.  Since clones inherit all the extends/instance
# variables/etc, we need to be able to call the original's mutation methods.
# But we can't imperatively alias the original methods as part of the
# DirtyMinder's Module definition because the DirtyMinder isn't the original
# class - it doesn't naturally have those methods to alias.
#
# Therefore, DirtyMinder has to use the Module#extended event to control the
# order/means of aliasing and actual method overriding.  By imperatively
# defining the hooks in their own Module (Hooks) and doing a 2nd extend from
# within the 1st, we get the nifty #method(:foo) indication of who actually
# overrode/wrapped a given method.  Awesome!
#
# NOTE: Since we use {Array,Hash}#hash to compare mutated to self, and #hash
# accounts for/traverses nested structures, no "deep" inspection logic is
# technically necessary.  But Resource#dirty? only queries a cache of dirtied
# attributes, whose own population strategy is to hook assignment (instead of
# interrogating properties on demand).
#
# Maybe should think about optional "advisory" Property#dirty? method?  dkubb?
#
# TODO: add support for detecting mutations in nested objects, but we can't
#       catch the assignment from here (yet?).
# TODO: add support for block-based mutating methods
# TODO: ensure we got all the Hash mutation methods
# TODO: ensure we covered all indirectly-mutable classes that DM uses underneath
#       a property type

module DataMapper
  class Property
    module DirtyMinder

      module Hooker
        MUTATION_METHODS = {
          ::Array => %w{
            []= push << shift pop insert unshift delete
            delete_at replace fill clear
            slice! reverse! rotate! compact! flatten! uniq!
            collect! map! sort! sort_by! reject! delete_if!
            select! shuffle!
          }.select { |meth| ::Array.instance_methods.include?(meth) },

          ::Hash => %w{
            []= store delete delete_if replace update
            delete rehash shift clear
            merge! reject! select!
          }.select { |meth| ::Hash.instance_methods.include?(meth) },
        }

        def self.extended(instance)
          return unless MUTATION_METHODS.keys.include?(instance.class)

          MUTATION_METHODS[instance.class].each do |meth|
            next unless instance.respond_to?(meth)
            instance.instance_eval("alias :'orig_#{meth}' :'#{meth}'")
          end

          instance.extend const_get("#{instance.class}Hooks")
        end

        MUTATION_METHODS.each do |klass, methods|
          # FIXME: has to be a better way to define a new module space
          eval("module #{klass}Hooks; end")

          const_get("#{klass}Hooks").module_eval do
            methods.each do |meth|
              define_method(meth) do |*args, &blk|
                new = self.clone
                ret = new.send(:"orig_#{meth}", *args, &blk)
                mark_dirty_if_different(self, new)
                ret
              end
            end
          end
        end

        def track(resource, property)
          @resource, @property = resource, property
        end

        private

        def mark_dirty_if_different(before, after)
          return if before.hash == after.hash
          @resource.attribute_set(@property.name, after)
        end
      end # Hooker

      # This catches any direct assignment, allowing us to hook the Hash or Array.
      def set(resource, value)
        hook_value(resource, value) unless value.kind_of? Hooker
        super
      end

      # This gets called when Resource#reload is called (instead of #set).
      def set!(resource, value)
        hook_value(resource, value) unless value.kind_of? Hooker
        super
      end

      private

      def hook_value(resource, value)
        return if value.kind_of? Hooker

        value.extend Hooker
        value.track(resource, self)
      end

    end # DirtyMinder
  end # Property
end # DataMapper
