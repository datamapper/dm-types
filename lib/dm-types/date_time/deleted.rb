require 'dm-types/support/paranoid_resource'

module DataMapper
  class Property
    class DateTime::Deleted < DateTime
      default   nil
      lazy      true

      # @api private
      def bind
        unless model < DataMapper::Types::Support::ParanoidResource
          model.__send__(:include, DataMapper::Types::Support::ParanoidResource)
        end

        model.paranoid_properties << self
        model.default_scope(repository_name).update(name => false)
      end

      def paranoid_value
        ::DateTime.now
      end
    end # class DateTime::Deleted

    ParanoidDateTime = DateTime::Deleted
  end # module Property
end # module DataMapper
