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

        model.set_paranoid_property(name) { ::DateTime.now }
        model.default_scope(repository_name).update(name => false)
      end
    end # class ParanoidDateTime
  end # module Property
end # module DataMapper
