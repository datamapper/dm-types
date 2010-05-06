require 'ipaddr'
require 'dm-core'

module DataMapper
  class Property
    class IPAddress < String
      length 39

      def primitive?(value)
        value.kind_of?(IPAddr)
      end

      def load(value)
        if value.nil?
          nil
        elsif value.is_a?(::String) && !value.empty?
          IPAddr.new(value)
        elsif value.is_a?(::String) && value.empty?
          IPAddr.new("0.0.0.0")
        else
          raise ArgumentError.new("+value+ must be nil or a String")
        end
      end

      def dump(value)
        return nil if value.nil?
        value.to_s
      end

      def typecast_to_primitive(value)
        load(value)
      end
    end # class IPAddress
  end # module Property
end # module DataMapper
