require 'dm-types/support/date_stamp'
require 'dm-types/support/temporal_stamp_property'

module DataMapper
  class Property
    class Updated::Date < Date
      include Types::Support::DateStamp
      include Types::Support::TemporalStampProperty

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

    end # class Updated::Date
  end # class Property
end # module DataMapper
