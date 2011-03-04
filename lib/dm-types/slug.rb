require 'dm-core'
require 'stringex'

module DataMapper
  class Property
    class Slug < String

      # Maximum length chosen because URI type is limited to 2000
      # characters, and a slug is a component of a URI, so it should
      # not exceed the maximum URI length either.
      length 2000

      def typecast(value)
        if value.nil?
          nil
        elsif value.respond_to?(:to_str)
          escape(value.to_str)
        else
          raise ArgumentError, '+value+ must be nil or respond to #to_str'
        end
      end

      def escape(string)
        string.to_url
      end

    end # class Slug
  end # class Property
end # module DataMapper
