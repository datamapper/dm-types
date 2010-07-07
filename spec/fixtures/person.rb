module DataMapper
  module TypesFixtures
    class Person
      #
      # Behaviors
      #

      include DataMapper::Resource

      #
      # Properties
      #

      property :id,         Serial
      property :name,       String
      property :positions,  Json
      property :inventions, Yaml

      property :interests, CommaSeparatedList

      property :password, BCryptHash
    end
  end
end
