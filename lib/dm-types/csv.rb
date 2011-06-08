require 'dm-core'
require 'dm-types/support/dirty_minder'

if RUBY_VERSION >= '1.9.0'
  require 'csv'
else
  require 'fastercsv'  # must be ~>1.5
  CSV = FasterCSV unless defined?(CSV)
end

module DataMapper
  class Property
    class Csv < Text

      def primitive?(value)
        super || value.kind_of?(::Array)
      end

      def load(value)
        case value
        when ::String then CSV.parse(value)
        when ::Array  then value
        end
      end

      def dump(value)
        case value
          when ::Array
            CSV.generate { |csv| value.each { |row| csv << row } }
          when ::String then value
        end
      end

      include ::DataMapper::Property::DirtyMinder

    end # class Csv
  end # class Property
end # module DataMapper
