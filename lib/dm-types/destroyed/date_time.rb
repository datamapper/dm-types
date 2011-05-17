require 'dm-types/support/paranoid_property'

module DataMapper
  class Property
    module Destroyed
      class DateTime < ::DataMapper::Property::DateTime
        include Types::Support::ParanoidProperty

        default   nil
        lazy      true

        def stamp_value
          ::DateTime.now
        end

      end # class DateTime
    end # module Destroyed

    ParanoidDateTime = Destroyed::DateTime
  end # module Property
end # module DataMapper
