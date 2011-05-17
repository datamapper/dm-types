require "dm-types/support/temporally_stamped_resource"

module DataMapper
  module Types
    module Support
      module CreateStamp

        def bind
          unless model < TemporallyStampedResource
            model.__send__ :include, TemporallyStampedResource
          end

          model.temporally_stamped_properties << self
        end

        def temporally_stamp_resource(resource)
          resource[name] ||= current_temporal_value if resource.new?
        end

      end # module CreateStamp
    end # module Support
  end # class Property
end # module DataMapper
