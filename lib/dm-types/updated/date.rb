require 'dm-types/support/datestamp'
require 'dm-types/support/update_stamp'

module DataMapper
  class Property
    module Updated
      class Date < ::DataMapper::Property::Date
        include Types::Support::Datestamp
        include Types::Support::UpdateStamp

        required true
        auto_validation false if accepted_options.include?(:auto_validation)

      end # class Date
    end # module Updated
  end # class Property
end # module DataMapper
