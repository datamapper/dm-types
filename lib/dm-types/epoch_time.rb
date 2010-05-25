require 'dm-core'

begin
  # provide Time#utc_time for DateTime#to_time in AS
  require 'active_support/core_ext/time/calculations'
rescue LoadError
  # do nothing, extlib is being used and does not require this method
end

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
          when ::DateTime        then value.to_time.to_i
        end
      end
    end # class EpochTime
  end # class Property
end # module DataMapper
