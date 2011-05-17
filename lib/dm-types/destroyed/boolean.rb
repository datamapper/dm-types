require 'dm-types/support/paranoid_resource'

module DataMapper
  class Property
    class Destroyed::Boolean < Boolean
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

      def stamp_resource(resource)
        resource[name] = true
      end
    end # class Destroyed::Boolean

    ParanoidBoolean = Destroyed::Boolean
  end # module Property
end # module DataMapper
