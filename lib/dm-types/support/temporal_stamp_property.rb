require "dm-types/support/temporally_stamped_resource"

module DataMapper
  module Types
    module Support
      module TemporalStampProperty

        def bind
          unless model < TemporallyStampedResource
            model.__send__ :include, TemporallyStampedResource
          end

          model.temporally_stamped_properties << self
        end

        def stamp_resource(resource)
          resource[name] = stamp_value
        end

      end # module CreateStamp
    end # module Support
  end # class Property
end # module DataMapper
