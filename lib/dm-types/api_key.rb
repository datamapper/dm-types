require 'dm-core'

require 'digest/sha1'

module DataMapper
  class Property
    class APIKey < String

      # The amount of random seed data to use to generate tha API Key
      PADDING = 256

      length 40
      unique true
      default proc { APIKey.generate }

      #
      # Generates a new API Key.
      #
      # @return [String]
      #   The new API Key.
      #
      def self.generate
        sha1 = Digest::SHA1.new

        PADDING.times { sha1 << rand(256).chr }
        return sha1.hexdigest
      end
    end
  end
end
