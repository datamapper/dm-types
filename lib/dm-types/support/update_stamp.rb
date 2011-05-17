require "dm-types/support/stamped_resource"

module DataMapper
  module Types
    module Support
      module UpdateStamp

        def bind
          model.__send__ :include, StampedResource unless model < StampedResource
          model.stamped_properties << self
        end

        def stamp(resource)
          resource[name] = current_stamp
        end

      end # module UpdateStamp
    end # module Support
  end # class Property
end # module DataMapper
