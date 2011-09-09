module DataMapper
  module TypesFixtures

    class CustomWithoutOptions
      include ::DataMapper::Resource

      property :id, Serial
      property :text, Text
      property :json, Json
    end

    class CustomWithOptions
      include ::DataMapper::Resource

      property :id, Serial
      property :text, Text, :length => 2**24-1
      property :json, Json, :length => 2**24-1
    end
  end
end
