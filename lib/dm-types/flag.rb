require 'dm-core'
require 'dm-types/support/flags'

module DataMapper
  class Property
    class Flag < Integer

      include Flags

      def initialize(model, name, options = {})
        super

        @flag_map = {}

        flags = options.fetch(:flags, self.class.flags)
        flags.each_with_index do |flag, i|
          flag_map[i] = flag
        end
      end

      def load(value)
        return [] if value.nil? || value <= 0

        begin
          matches = []

          0.upto(flag_map.size - 1) do |i|
            matches << flag_map[i] if value[i] == 1
          end

          matches.compact
        rescue TypeError, Errno::EDOM
          []
        end
      end

      def dump(value)
        unless value.nil?
          flags = Array(value).map { |flag| flag.to_sym }
          flags.uniq!

          flag = 0

          flag_map.invert.values_at(*flags).each do |i|
            next if i.nil?
            flag += (1 << i)
          end

          flag
        end
      end

      def typecast(value)
        case value
          when nil     then nil
          when ::Array then value.map { |v| v.to_sym }
          else [value.to_sym]
        end
      end

    end # class Flag
  end # class Property
end # module DataMapper
