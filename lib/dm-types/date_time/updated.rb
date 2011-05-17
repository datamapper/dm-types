require 'dm-types/support/timestamp'
require 'dm-types/support/create_stamp'

module DataMapper
  class Property
    class DateTime::Updated < DateTime
      include Support::Timestamp
      include Support::UpdateStamp

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

    end # class DateTime::Updated
  end # class Property
end # module DataMapper
