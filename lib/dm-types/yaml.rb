require 'yaml'
require 'dm-core'

module DataMapper
  class Property
    class Yaml < Text
      def custom?
        true
      end

      def load(value)
        if value.nil?
          nil
        elsif value.is_a?(::String)
          ::YAML.load(value)
        else
          raise ArgumentError.new("+value+ of a property of YAML type must be nil or a String")
        end
      end

      def dump(value)
        if value.nil?
          nil
        elsif value.is_a?(::String) && value =~ /^---/
          value
        else
          ::YAML.dump(value)
        end
      end

      def typecast(value)
        value
      end
    end # class Yaml
  end # class Property
end # module DataMapper
