require 'dm-types/support/datestamp'
require 'dm-types/support/create_stamp'

module DataMapper
  class Property
    class UpdatedDate < DateTime
      include Support::Datestamp
      include Support::UpdateStamp

      required true
      auto_validation false if accepted_options.include?(:auto_validation)

    end # class CreatedDate
  end # class Property
end # module DataMapper
