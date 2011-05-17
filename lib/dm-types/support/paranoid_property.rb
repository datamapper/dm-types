require "dm-types/support/paranoid_resource"

module DataMapper
  module Types
    module Support
      module ParanoidProperty

        # @api private
        def bind
          unless model < DataMapper::Types::Support::ParanoidResource
            model.__send__(:include, DataMapper::Types::Support::ParanoidResource)
          end

          model.paranoid_properties << self
          model.default_scope(repository_name).update(name => self.class.default)
        end

        def stamp_resource(resource)
          resource[name] = stamp_value
        end

      end # module UpdateStamp
    end # module Support
  end # class Property
end # module DataMapper
