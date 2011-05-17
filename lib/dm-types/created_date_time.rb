require 'dm-types/support/timestamp'
require 'dm-types/support/create_stamp'

module DataMapper
  class Property
    class CreatedDateTime < DateTime
      include Support::Timestamp
      include Support::CreateStamp

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

    end # class CreatedDateTime
  end # class Property
end # module DataMapper
