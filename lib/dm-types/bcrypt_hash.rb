require 'dm-core'
require 'bcrypt'

module DataMapper
  class Property
    class BCryptHash < String
      load_as BCrypt::Password

      length 60

      def load(value)
        unless value.nil?
          begin
            value_loaded?(value) ? value : BCrypt::Password.new(value)
          rescue BCrypt::Errors::InvalidHash
            BCrypt::Password.create(value, :cost => BCrypt::Engine::DEFAULT_COST)
          end
        end
      end

      def dump(value)
        load(value)
      end

      def typecast(value)
        load(value)
      end

    end # class BCryptHash
  end # class Property
end # module DataMapper
