require 'dm-types/support/paranoid_resource'

module DataMapper
  class Property
    module Destroyed
      class DateTime < ::DataMapper::Property::DateTime
        default   nil
        lazy      true

        # @api private
        def bind
          unless model < DataMapper::Types::Support::ParanoidResource
            model.__send__(:include, DataMapper::Types::Support::ParanoidResource)
          end

          model.paranoid_properties << self
          model.default_scope(repository_name).update(name => nil)
        end

        def mark_resource_destroyed(resource)
          resource[name] = ::DateTime.now
        end
      end # class DateTime
    end # module Destroyed

    ParanoidDateTime = Destroyed::DateTime
  end # module Property
end # module DataMapper
