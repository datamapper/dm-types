require 'dm-types/support/datestamp'
require 'dm-types/support/create_stamp'

module DataMapper
  class Property
    module Created
      class Date < ::DataMapper::Property::Date
        include Types::Support::Datestamp
        include Types::Support::CreateStamp

        required true
        auto_validation false if accepted_options.include?(:auto_validation)

      end # class Date
    end # module Created
  end # class Property
end # module DataMapper
