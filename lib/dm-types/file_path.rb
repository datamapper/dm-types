require 'pathname'
require 'dm-core'

module DataMapper
  class Property
    class FilePath < String

      length 255

      def primitive?(value)
        value.kind_of?(Pathname)
      end

      def valid?(value, negated = false)
        super || dump(value).kind_of?(::String)
      end

      def load(value)
        Pathname.new(value) unless DataMapper::Ext.blank?(value)
      end

      def dump(value)
        value.to_s unless DataMapper::Ext.blank?(value)
      end

      def typecast_to_primitive(value)
        load(value)
      end

    end # class FilePath
  end # class Property
end # module DataMapper
