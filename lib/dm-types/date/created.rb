require 'dm-types/support/datestamp'
require 'dm-types/support/create_stamp'

module DataMapper
  class Property
    class Date::Created < Date
      include Support::Datestamp
      include Support::CreateStamp

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

    end # class Date::Created
  end # class Property
end # module DataMapper
