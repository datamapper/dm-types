require 'dm-core'
require 'dm-types/support/flags'

# A DataMapper::Property that stores one of a predefined list of strings
# The list of allowed strings is defined in the call StringEnum[*allowed]
# Differences from Enum:
#   - primitive is String vs Integer (less efficient, more transparent)
#   - durable against reordering (Enum will break existing records if reordered)
module DataMapper
  class Property
    class StringEnum < String

      include Flags

      def initialize(model, name, options = {})
        super

        @flag_map = {}

        flags = options.fetch(:flags, self.class.flags)
        flags.each do |flag|
          @flag_map[flag.to_s] = flag
        end

        if defined?(::DataMapper::Validations)
          unless model.skip_auto_validation_for?(self)
            if self.class.ancestors.include?(Property::StringEnum)
              allowed = flag_map.values_at(*flag_map.keys.sort)
              model.validates_within name, model.options_with_message({ :set => allowed }, self, :within)
            end
          end
        end
      end

      def load(value)
        flag_map[value]
      end

      def dump(value)
        case value
        when ::Array then value.collect { |v| dump(v) }
        else              flag_map.invert[value]
        end
      end

      def typecast(value)
        return value if value.nil?
        # Attempt to typecast using the class of the first item in the map.
        case flag_map.values.first
        when ::Symbol then value.to_sym
        when ::String then value.to_s
        when ::Fixnum then value.to_i
        else               value
        end
      end

    end # class StringEnum
  end # class Property
end # module DataMapper
