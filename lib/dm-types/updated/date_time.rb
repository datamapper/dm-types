require 'dm-types/support/date_time_stamp'
require 'dm-types/support/temporal_stamp_property'

module DataMapper
  class Property
    module Updated
      class DateTime < ::DataMapper::Property::DateTime
        include Types::Support::DateTimeStamp
        include Types::Support::TemporalStampProperty

        required true
        auto_validation false if accepted_options.include?(:auto_validation)

      end # class DateTime
    end # module Updated
  end # class Property
end # module DataMapper
