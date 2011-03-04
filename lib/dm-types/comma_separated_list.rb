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
          v = []

          value.split(',').each do |element|
            element.strip!
            v << element unless element.empty?
          end

          super(v)
        else
          raise ArgumentError, "+value+ of CommaSeparatedList must be a string, an array or nil, but given #{value.inspect}"
        end
      end # dump

    end # CommaSeparatedList
  end # Property
end # DataMapper
