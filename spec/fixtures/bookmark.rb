module DataMapper
  module TypesFixtures

    class Bookmark
      #
      # Behaviors
      #

      include ::DataMapper::Resource

      #
      # Properties
      #

      property :id, Serial

      property :title,  String, :length => 255
      property :shared, Boolean
      property :uri,    URI
      property :tags,   Yaml
    end # Bookmark
  end
end
