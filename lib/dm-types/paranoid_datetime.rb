require 'dm-types/paranoid/base'

module DataMapper
  class Property
    class ParanoidDateTime < DateTime
      lazy      true

      # @api private
      def bind
        unless model < DataMapper::Types::Paranoid::Base
          model.__send__ :include, DataMapper::Types::Paranoid::Base
        end

        model.set_paranoid_property(name) { ::DateTime.now }
        model.default_scope(repository_name).update(name => nil)
      end
    end # class ParanoidDateTime
  end # module Property
end # module DataMapper
