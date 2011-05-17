require 'dm-core'

module DataMapper
  class Property
    autoload :CommaSeparatedList, 'dm-types/comma_separated_list'
    autoload :Csv,                'dm-types/csv'
    autoload :BCryptHash,         'dm-types/bcrypt_hash'
    autoload :Enum,               'dm-types/enum'
    autoload :EpochTime,          'dm-types/epoch_time'
    autoload :FilePath,           'dm-types/file_path'
    autoload :Flag,               'dm-types/flag'
    autoload :IPAddress,          'dm-types/ip_address'
    autoload :Json,               'dm-types/json'
    autoload :Regexp,             'dm-types/regexp'
    autoload :ParanoidBoolean,    'dm-types/destroyed/boolean'
    autoload :ParanoidDateTime,   'dm-types/destroyed/date_time'
    autoload :Slug,               'dm-types/slug'
    autoload :UUID,               'dm-types/uuid'
    autoload :URI,                'dm-types/uri'
    autoload :Yaml,               'dm-types/yaml'
    autoload :APIKey,             'dm-types/api_key'

    module Created
      autoload :Date,             'dm-types/created/date'
      autoload :DateTime,         'dm-types/created/date_time'
    end # module Created

    module Updated
      autoload :Date,             'dm-types/updated/date'
      autoload :DateTime,         'dm-types/updated/date_time'
    end # module Updated

    module Destroyed
      autoload :Boolean,          'dm-types/destroyed/boolean'
      autoload :DateTime,         'dm-types/destroyed/date_time'
    end # module Destroyed
  end # class Property
end # module DataMapper
