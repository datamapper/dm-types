# Approach
#
# We need to detect whether or not the underlying Hash or Array changed and
# update the dirty-ness of the encapsulating Resource accordingly (so that it
# will actually save).
#
# DM's state-tracking code only triggers dirty-ness by comparing the new value
# against the instance's Property's current value.  WRT mutation, we have to
# choose one of the following approaches:
#
#   (1) mutate a copy ("after"), then invoke the Resource assignment and State
#       tracking
#
#   (2) create a copy ("before"), mutate self ("after"), then invoke the
#       Resource assignment and State tracking
#
# (1) seemed simpler at first, but it required additional steps to alias the
# original (pre-hooked) methods before overriding them (so they could be invoked
# externally, ala self.clone.send("orig_...")), and more importantly it resulted
# in any external references keeping their old value (instead of getting the
# new), like so:
#
#   copy = instance.json
#   copy[:some] = :value
#   instance.json[:some] == :value
#    => true
#   copy[:some] == :value
#    => false  # fk!
#
# In order to do (2) and still have State tracking trigger normally, we need to
# ensure the Property has a different value other than self when the State
# tracking does the comparison.  This equates to setting the Property directly
# to the "before" value (a clone and thus a different object/value) before
# invoking the Resource Property/attribute assignment.
#
# The cloning of any value might sound expensive, but it's identical in cost to
# what you already had to do: assign a cloned copy in order to trigger
# dirty-ness (e.g. ::DataMapper::Property::Json):
#
#     model.json = model.json.merge({:some=>:value})
#
# Hooking Core Classes
#
# We want to hook certain methods on Hash and Array to trigger dirty-ness in the
# resource.  However, because these are core classes, they are individually
# mapped to C primitives and thus cannot be hooked through #send/#__send__.  We
# have to override each method, but we don't want to write a lot of code.
#
# Minimally Invasive
#
# We also want to extend behaviour of existing class instances instead of
# impersonating/delegating from a proxy class of our own, or overriding a global
# class behaviour.  This is the most flexible approach and least prone to error,
# since it leaves open the option for consumers to proxy or override global
# classes, and is less likely to interfere with method_missing/etc shenanigans.
#
# Nested Object Mutations
#
# Since we use {Array,Hash}#hash to compare before & after, and #hash accounts
# for/traverses nested structures, no "deep" inspection logic is technically
# necessary.  However, Resource#dirty? only queries a cache of dirtied
# attributes, whose own population strategy is to hook assignment (instead of
# interrogating properties on demand).  So the approach is still limited to
# top-level mutators.
#
# Maybe consider optional "advisory" Property#dirty? method for Resource#dirty?
# that custom properties could use for this purpose.
#
# TODO: add support for detecting mutations in nested objects, but we can't
#       catch the assignment from here (yet?).
# TODO: ensure we covered all indirectly-mutable classes that DM uses underneath
#       a property type
# TODO: figure out how to hook core class methods on RBX (which do use #send)

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
          }.select { |meth| ::Array.instance_methods.any? { |m| m.to_s == meth } },

          ::Hash => %w{
            []= store delete delete_if replace update
            delete rehash shift clear
            merge! reject! select!
          }.select { |meth| ::Hash.instance_methods.any? { |m| m.to_s == meth } },
        }

        def self.extended(instance)
          # FIXME: DirtyMinder is currently unsupported on RBX, because unlike
          # the other supported Rubies, RBX core class (e.g. Array, Hash)
          # methods use #send().  In other words, the other Rubies don't use
          # #send() (they map directly to their C functions).
          #
          # The current methodology takes advantage of this by using #send() to
          # forward method invocations we've hooked.  Supporting RBX will
          # require finding another way, possibly for all Rubies.  In the
          # meantime, something is better than nothing.
          return if defined?(RUBY_ENGINE) and RUBY_ENGINE == 'rbx'

          return unless type = MUTATION_METHODS.keys.find { |k| instance.kind_of?(k) }
          instance.extend const_get("#{type}Hooks")
        end

        MUTATION_METHODS.each do |klass, methods|
          methods.each do |meth|
            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              module #{klass}Hooks
                def #{meth}(*)
                  before = self.clone
                  ret    = super
                  after  = self

                  # If the hashes aren't equivalent then we know the Resource
                  # should be dirty.  However because we mutated self, normal
                  # State tracking will never trigger, because it will compare the
                  # new value - self - to the Resource's existing property value -
                  # which is also self.
                  #
                  # The solution is to drop 1 level beneath Resource State
                  # tracking and set the value of the property directly to the
                  # previous value (a different object now, because it's a clone).
                  # Then trigger the State tracking like normal.
                  if before.hash != after.hash
                    @property.set(@resource, before)
                    @resource.attribute_set(@property.name, after)
                  end

                  ret
                end
              end
            RUBY
          end
        end

        def track(resource, property)
          @resource, @property = resource, property
        end

      end # Hooker

      # Catch any direct assignment (#set), and any Resource#reload (set!).
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
