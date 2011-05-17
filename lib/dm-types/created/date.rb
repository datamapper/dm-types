require 'dm-types/support/date_stamp'
require 'dm-types/support/temporal_stamp_property'

module DataMapper
  class Property
    class Created::Date < Date
      include Types::Support::DateStamp
      include Types::Support::TemporalStampProperty

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

      def stamp_resource(resource)
        resource[name] ||= stamp_value if resource.new?
      end

    end # class Created::Date
  end # class Property
end # module DataMapper
