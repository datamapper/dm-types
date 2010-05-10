module DataMapper
  module Types
    module Fixtures

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

        property :password, BCryptHash if defined?(DataMapper::Property::BCryptHash)
      end
    end
  end
end
