require 'dm-types/support/timestamp'
require 'dm-types/support/create_stamp'

module DataMapper
  class Property
    module Created
      class DateTime < ::DataMapper::Property::DateTime
        include DataMapper::Types::Support::Timestamp
        include DataMapper::Types::Support::CreateStamp

        required true
        auto_validation false if accepted_options.include?(:auto_validation)

      end # class DateTime
    end # module Created
  end # class Property
end # module DataMapper
