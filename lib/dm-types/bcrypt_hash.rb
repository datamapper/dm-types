require 'dm-core'
require 'bcrypt'

module DataMapper
  class Property
    class BCryptHash < String

      length 60

      def primitive?(value)
        value.kind_of?(BCrypt::Password)
      end

      def load(value)
        if value.nil?
          nil
        elsif primitive?(value)
          value
        else
          BCrypt::Password.new(value)
        end
      rescue BCrypt::Errors::InvalidHash
        BCrypt::Password.create(value, :cost => BCrypt::Engine::DEFAULT_COST)
      end

      def dump(value)
        load(value)
      end

      def typecast_to_primitive(value)
        load(value)
      end

    end # class BCryptHash
  end # class Property
end # module DataMapper
