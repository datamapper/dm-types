require 'dm-types/support/timestamp'
require 'dm-types/support/update_stamp'

module DataMapper
  class Property
    class DateTime::Updated < DateTime
      include Types::Support::Timestamp
      include Types::Support::UpdateStamp

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

    end # class DateTime::Updated
  end # class Property
end # module DataMapper
