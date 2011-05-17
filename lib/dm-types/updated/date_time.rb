require 'dm-types/support/timestamp'
require 'dm-types/support/update_stamp'

module DataMapper
  class Property
    module Updated
      class DateTime < ::DataMapper::Property::DateTime
        include Types::Support::Timestamp
        include Types::Support::UpdateStamp

        required true
        auto_validation false if accepted_options.include?(:auto_validation)

      end # class DateTime
    end # module Updated
  end # class Property
end # module DataMapper
