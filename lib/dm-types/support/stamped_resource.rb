module DataMapper
  module Types
    module Support
      module StampedResource
        def self.included(model)
          model.before :save, :set_stamps
          model.instance_variable_set(:@stamped_properties, [].to_set)
          model.extend ClassMethods
        end

        # Saves the record with the updated_at/on attributes set to the current time.
        def touch
          set_stamps
          save
        end

      private

        def set_stamps
          model.stamped_properties.each { |property| property.stamp(self) }
        end

        module ClassMethods
          attr_reader :stamped_properties
        end # module ClassMethods

      end # module Timestamp
    end # module Support
  end # class Property
end # module DataMapper
