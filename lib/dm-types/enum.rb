require 'dm-core'
require 'dm-types/support/flags'

module DataMapper
  class Property
    class Enum < Integer

      include Flags

      def initialize(model, name, options = {})
        super

        @flag_map = {}

        flags = options.fetch(:flags, self.class.flags)
        flags.each_with_index do |flag, i|
          @flag_map[i + 1] = flag
        end

        if defined?(::DataMapper::Validations)
          unless model.skip_auto_validation_for?(self)
            if self.class.ancestors.include?(Property::Enum)
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

      def typecast_to_primitive(value)
        # Attempt to typecast using the class of the first item in the map.
        case flag_map[1]
        when ::Symbol then value.to_sym
        when ::String then value.to_s
        when ::Fixnum then value.to_i
        else               value
        end
      end

    end # class Enum
  end # class Property
end # module DataMapper
