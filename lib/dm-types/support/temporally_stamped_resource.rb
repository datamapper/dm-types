module DataMapper
  module Types
    module Support
      module TemporallyStampedResource

        def self.included(model)
          model.before :save, :set_temporal_stamps
          model.instance_variable_set(:@temporally_stamped_properties, [].to_set)
          model.extend ClassMethods
        end

        # Saves the record with the updated_at/on attributes set to the current time.
        def touch
          set_temporal_stamps(true)
          save
        end

      private

        def set_temporal_stamps(set_stamps = self.dirty?)
          return unless set_stamps

          model.temporally_stamped_properties.each do |property|
            property.temporally_stamp_resource(self)
          end
        end

        module ClassMethods
          attr_reader :temporally_stamped_properties

          def inherited(model)
            model.instance_variable_set :@temporally_stamped_properties,
                                         @temporally_stamped_properties.dup
            super
          end
        end # module ClassMethods

      end # module Timestamp
    end # module Support
  end # class Property
end # module DataMapper
