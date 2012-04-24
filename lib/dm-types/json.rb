require 'dm-core'
require 'dm-types/support/dirty_minder'
require 'multi_json'

module DataMapper
  class Property
    class Json < Text
      load_as ::Object

      def load(value)
        if value.nil? || value_loaded?(value)
          value
        elsif value.is_a?(::String)
          typecast(value)
        else
          raise ArgumentError.new("+value+ of a property of JSON type must be nil or a String")
        end
      end

      def dump(value)
        if value.nil? || value.is_a?(::String)
          value
        else
          MultiJson.dump(value)
        end
      end

      def typecast(value)
        return if value.nil?

        if value_loaded?(value)
          value
        else
          MultiJson.load(value.to_s)
        end
      end

      def value_loaded?(value)
        value.kind_of?(::Array) || value.kind_of?(::Hash)
      end

      include ::DataMapper::Property::DirtyMinder

    end # class Json

    JSON = Json

  end # class Property
end # module DataMapper
