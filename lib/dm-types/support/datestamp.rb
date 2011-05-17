module DataMapper
  class Property
    module Datestamp

      def current
        ::Date.today
      end

    end # module Datestamp
  end # class Property
end # module DataMapper
