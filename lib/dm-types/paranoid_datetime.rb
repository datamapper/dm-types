require 'dm-types/support/paranoid_resource'

module DataMapper
  class Property
    class ParanoidDateTime < DateTime
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
    end # class ParanoidDateTime
  end # module Property
end # module DataMapper
