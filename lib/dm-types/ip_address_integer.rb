require 'dm-core'
require 'ipaddr'

module DataMapper
  class Property
    class IPAddressInteger < Integer

      def initialize(name, model, options = {})
        Property.accept_options(:version)
        super
        
        @format = if options[:version] == :ipv6
          Socket::AF_INET6
        else
          Socket::AF_INET
        end
      end

      def load(value)
        return nil if value.nil?
        
        case value
          when ::Integer then  IPAddr.new(value, @format)
          else raise ArgumentError.new("+value+ must be nil or an Integer")
        end
      end

      def dump(value)
        case value
          when ::IPAddr  then value.to_i
          when ::String  then IPAddr.new(value, @format).to_i unless value.empty?
          when ::Integer then value
        end
      end

      def typecast_to_primitive(value)
        dump(value)
      end

    end # class IPAddressInteger
  end # class Property
end # module DataMapper
