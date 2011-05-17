require 'dm-types/support/paranoid_resource'

module DataMapper
  class Property
    module Destroyed
      class Boolean < ::DataMapper::Property::Boolean
        default   false
        lazy      true

        # @api private
        def bind
          unless model < DataMapper::Types::Support::ParanoidResource
            model.__send__(:include, DataMapper::Types::Support::ParanoidResource)
          end

          model.paranoid_properties << self
          model.default_scope(repository_name).update(name => false)
        end

        def mark_resource_destroyed(resource)
          resource[name] = true
        end
      end # class Boolean
    end # module Destroyed

    ParanoidBoolean = Destroyed::Boolean
  end # module Property
end # module DataMapper
