require 'dm-types/support/paranoid_property'

module DataMapper
  class Property
    class Destroyed::DateTime < DateTime
      include Types::Support::ParanoidProperty

      default   nil
      lazy      true

      def stamp_value
        ::DateTime.now
      end
    end # class Destroyed::DateTime

    ParanoidDateTime = Destroyed::DateTime
  end # module Property
end # module DataMapper
