require 'dm-core'

if RUBY_VERSION >= '1.9.0'
  require 'csv'
else
  require 'fastercsv'  # must be ~>1.5
  CSV = FasterCSV unless defined?(CSV)
end

module DataMapper
  class Property
    class Csv < Text
      def load(value)
        case value
          when ::String then CSV.parse(value)
          when ::Array  then value
          else
            nil
        end
      end

      def dump(value)
        case value
          when ::Array  then CSV.generate { |csv| value.each { |row| csv << row } }
          when ::String then value
          else
            nil
        end
      end
    end # class Csv
  end # class Property
end # module DataMapper
