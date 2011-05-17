require 'dm-types/support/paranoid_resource'

module DataMapper
  class Property
    class Destroyed::DateTime < DateTime
      default   nil
      lazy      true

      # @api private
      def bind
        unless model < DataMapper::Types::Support::ParanoidResource
          model.__send__(:include, DataMapper::Types::Support::ParanoidResource)
        end

        model.paranoid_properties << self
        model.default_scope(repository_name).update(name => self.class.default)
      end

      def stamp_resource(resource)
        resource[name] = ::DateTime.now
      end
    end # class Destroyed::DateTime

    ParanoidDateTime = Destroyed::DateTime
  end # module Property
end # module DataMapper
