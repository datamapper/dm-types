module DataMapper
  module Types
    module Support
      module Timestamp

        def current_stamp
          ::DateTime.now
        end

      end # module Timestamp
    end # module Support
  end # class Property
end # module DataMapper
