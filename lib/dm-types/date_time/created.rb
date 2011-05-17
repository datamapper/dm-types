require 'dm-types/support/timestamp'
require 'dm-types/support/create_stamp'

module DataMapper
  class Property
    class DateTime::Created < DateTime
      include Types::Support::Timestamp
      include Types::Support::CreateStamp

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

    end # class DateTime::Created
  end # class Property
end # module DataMapper
