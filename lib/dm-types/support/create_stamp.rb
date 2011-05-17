module DataMapper
  class Property
    module Support
      module CreateStamp

        def bind
          property = self
          model.before :save do
            self[property.name] ||= property.current if dirty? && new?
          end
        end

      end # module CreateStamp
    end # module Support
  end # class Property
end # module DataMapper
