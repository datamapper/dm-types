require 'dm-types/support/paranoid_property'

module DataMapper
  class Property
    class Destroyed::Boolean < Boolean
      include Types::Support::ParanoidProperty

      default   false
      lazy      true

      def stamp_value
        true
      end
    end # class Destroyed::Boolean

    ParanoidBoolean = Destroyed::Boolean
  end # module Property
end # module DataMapper
