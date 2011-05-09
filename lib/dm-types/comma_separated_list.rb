require 'dm-core'
require 'dm-types/yaml'

module DataMapper
  class Property
    class CommaSeparatedList < Yaml

      def dump(value)
        if value.nil?
          nil
        elsif value.kind_of?(::Array)
          super(value)
        elsif value.kind_of?(::String)
          super(comma_separated_string_to_array(value))
        else
          raise ArgumentError, "+value+ of CommaSeparatedList must be a string, an array or nil, but given #{value.inspect}"
        end
      end # dump

    private

      def comma_separated_string_to_array(string)
        array = []

        string.split(',').each do |element|
          element.strip!
          array << element unless element.empty?
        end

        array
      end

    end # CommaSeparatedList
  end # Property
end # DataMapper
