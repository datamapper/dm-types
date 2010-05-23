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
        else
          begin
            primitive?(value) ? value : BCrypt::Password.new(value)
          rescue BCrypt::Errors::InvalidHash
            BCrypt::Password.create(value, :cost => BCrypt::Engine::DEFAULT_COST)
          end
        end
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

# The Bcrypt::Password#hash method returns a String and not an Integer,
# which is required by any ruby class that uses a Hash underneath. Removing
# this method does not cause any spec failures in Bcrypt::Password
BCrypt::Password.class_eval { remove_method :hash }
