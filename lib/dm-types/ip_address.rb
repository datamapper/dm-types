require 'ipaddr'
require 'dm-core'

module DataMapper
  class Property
    class IPAddress < String
      load_as IPAddr

      length 39

      def load(value)
        if value.nil? || value_loaded?(value)
          value
        elsif value.is_a?(::String)
          unless value.empty?
            IPAddr.new(value)
          else
            IPAddr.new("0.0.0.0")
          end
        else
          raise ArgumentError.new("+value+ must be nil or a String")
        end
      end

      def dump(value)
        value.to_s unless value.nil?
      end

      def typecast(value)
        load(value) unless value.nil?
      end

    end # class IPAddress
  end # module Property
end # module DataMapper
