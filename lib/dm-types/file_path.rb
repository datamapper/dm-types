require 'pathname'
require 'dm-core'

module DataMapper
  class Property
    class FilePath < String
      load_as Pathname

      length 255

      def load(value)
        Pathname.new(value) unless DataMapper::Ext.blank?(value)
      end

      def dump(value)
        value.to_s unless DataMapper::Ext.blank?(value)
      end

      def typecast(value)
        load(value)
      end

    end # class FilePath
  end # class Property
end # module DataMapper
