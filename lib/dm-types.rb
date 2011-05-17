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
    autoload :ParanoidBoolean,    'dm-types/boolean/deleted'
    autoload :ParanoidDateTime,   'dm-types/date_time/deleted'
    autoload :Slug,               'dm-types/slug'
    autoload :UUID,               'dm-types/uuid'
    autoload :URI,                'dm-types/uri'
    autoload :Yaml,               'dm-types/yaml'
    autoload :APIKey,             'dm-types/api_key'

    Boolean.autoload :Deleted,    'dm-types/boolean/deleted'

    Date.autoload :Created,       'dm-types/date/created'
    Date.autoload :Updated,       'dm-types/date/updated'
    # Date.autoload :Deleted,   'dm-types/date/deleted'

    DateTime.autoload :Created,   'dm-types/date_time/created'
    DateTime.autoload :Updated,   'dm-types/date_time/updated'
    DateTime.autoload :Deleted,   'dm-types/date_time/deleted'
  end # class Property
end # module DataMapper
