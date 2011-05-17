module DataMapper
  module Types
    module Support
      module Datestamp

        def current_stamp
          ::Date.today
        end

      end # module Datestamp
    end # module Support
  end # class Property
end # module DataMapper
