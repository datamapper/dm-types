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
        return if value.nil?
        flags = Array(value).map { |flag| flag.to_sym }.flatten.uniq
        flag_map.invert.values_at(*flags).compact.inject(0) { |sum, i| sum += 1 << i }
      end

      def typecast(value)
        case value
          when nil   then nil
          when ::Array then value.map {|v| v.to_sym}
          else [value.to_sym]
        end
      end
    end # class Flag
  end # class Property
end # module DataMapper
