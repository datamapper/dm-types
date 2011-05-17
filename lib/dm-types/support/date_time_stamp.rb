module DataMapper
  module Types
    module Support
      module DateTimeStamp

        def stamp_value
          ::DateTime.now
        end

      end # module DateTimeStamp
    end # module Support
  end # module Types
end # module DataMapper
