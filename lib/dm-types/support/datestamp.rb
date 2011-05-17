module DataMapper
  module Types
    module Support
      module Datestamp

        def current_temporal_value
          ::Date.today
        end

      end # module Datestamp
    end # module Support
  end # class Property
end # module DataMapper
