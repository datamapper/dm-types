require 'addressable/uri'
require 'dm-core'

module DataMapper
  class Property
    class URI < String

      # Maximum length chosen based on recommendation:
      # http://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-an-url
      length 2000

      def custom?
        true
      end

      def primitive?(value)
        value.kind_of?(Addressable::URI)
      end

      def valid?(value, negated = false)
        super || primitive?(value) || value.kind_of?(::String)
      end

      def load(value)
        Addressable::URI.parse(value)
      end

      def dump(value)
        value.to_s unless value.nil?
      end

      def typecast_to_primitive(value)
        load(value)
      end

    end # class URI
  end # class Property
end # module DataMapper
