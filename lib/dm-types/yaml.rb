require 'yaml'
require 'dm-core'
require 'dm-types/support/dirty_minder'

module DataMapper
  class Property
    class Yaml < Text
      load_as ::Object

      def load(value)
        if value.nil?
          nil
        elsif value.is_a?(::String)
          ::YAML.load(value)
        else
          raise ArgumentError, '+value+ of a property of YAML type must be nil or a String'
        end
      end

      def dump(value)
        value = ::String.new(value) if value.kind_of?(::String)
        #p value.object_id if value.kind_of?(::String)
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

      include ::DataMapper::Property::DirtyMinder

    end # class Yaml
  end # class Property
end # module DataMapper
