require 'dm-core'

module DataMapper
  class Property
    class EpochTime < Integer

      def load(value)
        if value.kind_of?(::Numeric)
          ::Time.at(value.to_i)
        else
          value
        end
      end

      def dump(value)
        case value
          when ::Numeric, ::Time then value.to_i
          when ::DateTime        then datetime_to_time(value).to_i
        end
      end

    private

      def datetime_to_time(datetime)
        utc = datetime.new_offset(0)
        ::Time.utc(utc.year, utc.month, utc.day, utc.hour, utc.min, utc.sec)
      end

    end # class EpochTime
  end # class Property
end # module DataMapper
