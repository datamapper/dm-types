require 'pathname'
require 'dm-core'

module DataMapper
  class Property
    class FilePath < String
      length 255

      def primitive?(value)
        value.kind_of?(Pathname)
      end

      def load(value)
        if value.blank?
          nil
        else
          Pathname.new(value)
        end
      end

      def dump(value)
        return nil if value.blank?
        value.to_s
      end

      def typecast_to_primitive(value)
        load(value)
      end
    end # class FilePath
  end # class Property
end # module DataMapper
