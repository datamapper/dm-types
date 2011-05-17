module DataMapper
  module Types
    module Support
      module DateStamp

        def stamp_value
          ::Date.today
        end

      end # module DateStamp
    end # module Support
  end # module Types
end # module DataMapper
