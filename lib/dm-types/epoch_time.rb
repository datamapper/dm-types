require 'dm-core'
require 'dm-core/ext/date_time'

module DataMapper
  class Property
    class EpochTime < Integer
      def load(value)
        if value.kind_of?(::Integer)
          ::Time.at(value)
        else
          value
        end
      end

      def dump(value)
        case value
          when ::Integer, ::Time then value.to_i
          when ::DateTime        then datetime_to_time(value).to_i
        end
      end

    private
      def datetime_to_time(datetime)
        d = datetime
        d.offset == 0 ? utc_time_with_fallback(d.year, d.month, d.day, d.hour, d.min, d.sec) : d
      end

      # Returns a new Time if requested year can be accommodated by Ruby's
      # Time class (i.e., if year is within either 1970..2038 or 1902..2038,
      # depending on system architecture); otherwise returns a DateTime
      def utc_time_with_fallback(year, month = 1, day = 1, hour = 0, min = 0, sec = 0, usec = 0)
        time = ::Time.utc(year, month, day, hour, min, sec, usec)

        # This check is needed because Time.utc(y) returns a time object in the
        # 2000s for 0 <= y <= 138.
        time.year == year ? time : ::DateTime.civil(year, month, day, hour, min, sec, 0)
      rescue
        ::DateTime.civil(year, month, day, hour, min, sec, 0)
      end
    end # class EpochTime
  end # class Property
end # module DataMapper
