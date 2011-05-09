require 'ipaddr'
require 'dm-core'

module DataMapper
  class Property
    class IPAddress < String

      length 39

      def primitive?(value)
        value.kind_of?(IPAddr)
      end

      def valid?(value, negated = false)
        super || dump(value).kind_of?(::String)
      end

      def load(value)
        if value.nil?
          nil
        elsif value.is_a?(::String)
          value = "0.0.0.0" if DataMapper::Ext.blank?(value)
          IPAddr.new(value)
        else
          raise ArgumentError.new("+value+ must be nil or a String")
        end
      end

      def dump(value)
        value.to_s unless value.nil?
      end

      def typecast_to_primitive(value)
        load(value)
      end

    end # class IPAddress
  end # module Property
end # module DataMapper
