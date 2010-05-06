require 'dm-types/paranoid/base'

module DataMapper
  class Property
    class ParanoidBoolean < Boolean
      default   false
      lazy      true

      # @api private
      def bind
        property_name = name.inspect

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          include Paranoid::Base

          set_paranoid_property(#{property_name}) { true }

          default_scope(#{repository_name.inspect}).update(#{property_name} => false)
        RUBY
      end
    end # class ParanoidBoolean
  end # module Property
end # module DataMapper
