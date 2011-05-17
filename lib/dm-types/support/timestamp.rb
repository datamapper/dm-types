module DataMapper
  class Property
    module Timestamp

      def current
        ::DateTime.now
      end

    end # module Timestamp
  end # class Property
end # module DataMapper
