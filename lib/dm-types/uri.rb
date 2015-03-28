require 'addressable/uri'
require 'dm-core'

module DataMapper
  class Property
    class URI < String
      load_as Addressable::URI

      # Maximum length chosen based on recommendation:
      # http://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-an-url
      length 2083

      def load(value)
        uri = Addressable::URI.parse(value)
        uri.normalize unless uri.nil?
      end

      def dump(value)
        value.to_str unless value.nil?
      end

      def typecast(value)
        load(value) unless value.nil?
      end

    end # class URI
  end # class Property
end # module DataMapper
