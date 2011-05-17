require 'dm-types/support/date_stamp'
require 'dm-types/support/temporal_stamp_property'

module DataMapper
  class Property
    module Updated
      class Date < ::DataMapper::Property::Date
        include Types::Support::DateStamp
        include Types::Support::TemporalStampProperty

        required true
        auto_validation false if accepted_options.include?(:auto_validation)

      end # class Date
    end # module Updated
  end # class Property
end # module DataMapper
