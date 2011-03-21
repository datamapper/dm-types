module DataMapper
  module TypesFixtures
    class APIUser

      include DataMapper::Resource

      property :id, Serial

      property :name, String

      property :api_key, APIKey
    end
  end
end
