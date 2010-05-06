require 'dm-core'

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
          when ::DateTime      then value.to_time.to_i
        end
      end
    end # class EpochTime
  end # class Property
end # module DataMapper
