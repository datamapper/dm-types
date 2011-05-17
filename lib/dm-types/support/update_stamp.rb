module DataMapper
  class Property
    module UpdateStamp

      def bind
        property = self
        model.before :save do
          self[property.name] = property.current if dirty?
        end
      end

    end # module UpdateStamp
  end # class Property
end # module DataMapper
