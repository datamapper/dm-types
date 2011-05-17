require 'dm-types/support/datestamp'
require 'dm-types/support/create_stamp'

module DataMapper
  class Property
    class CreatedDate < DateTime
      include Support::Datestamp
      include Support::CreateStamp

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

    end # class CreatedDate
  end # class Property
end # module DataMapper
