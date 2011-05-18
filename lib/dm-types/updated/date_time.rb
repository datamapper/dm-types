require 'dm-types/support/date_time_stamp'
require 'dm-types/support/temporal_stamp_property'

module DataMapper
  class Property
    class Updated::DateTime < DateTime
      include Types::Support::DateTimeStamp
      include Types::Support::TemporalStampProperty

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

    end # class Updated::DateTime
  end # class Property
end # module DataMapper
