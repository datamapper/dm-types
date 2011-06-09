require 'dm-types/support/date_time_stamp'
require 'dm-types/support/temporal_stamp_property'

module DataMapper
  class Property
    class Created::DateTime < DateTime
      include Types::Support::DateTimeStamp
      include Types::Support::TemporalStampProperty

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

      def stamp_resource(resource)
        resource[name] ||= stamp_value if resource.new?
      end

    end # class Created::DateTime
  end # class Property
end # module DataMapper
