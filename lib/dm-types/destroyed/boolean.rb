require 'dm-types/support/paranoid_property'

module DataMapper
  class Property
    module Destroyed
      class Boolean < ::DataMapper::Property::Boolean
        include Types::Support::ParanoidProperty

        default   false
        lazy      true

        def stamp_value
          true
        end

      end # class Boolean
    end # module Destroyed

    ParanoidBoolean = Destroyed::Boolean
  end # module Property
end # module DataMapper
