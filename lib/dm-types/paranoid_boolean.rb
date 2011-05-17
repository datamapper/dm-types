require 'dm-types/support/paranoid_resource'

module DataMapper
  class Property
    class ParanoidBoolean < Boolean
      default   false
      lazy      true

      # @api private
      def bind
        unless model < DataMapper::Types::Support::ParanoidResource
          model.__send__(:include, DataMapper::Types::Support::ParanoidResource)
        end

        model.set_paranoid_property(name) { true }
        model.default_scope(repository_name).update(name => false)
      end
    end # class ParanoidBoolean
  end # module Property
end # module DataMapper
