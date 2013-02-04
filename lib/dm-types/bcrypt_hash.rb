require 'dm-core'
require 'bcrypt'

module DataMapper
  class Property
    class BCryptHash < String
      include PassThroughLoadDump

      length 60

      def typecast(value)
        return value if value.nil? || value.kind_of?(BCrypt::Password)
        BCrypt::Password.new(value)
      rescue BCrypt::Errors::InvalidHash
        BCrypt::Password.create(value)
      end

      def dump(value)
        hash = typecast(value)
        hash.to_s if hash
      end

    end # class BCryptHash
  end # class Property
end # module DataMapper
