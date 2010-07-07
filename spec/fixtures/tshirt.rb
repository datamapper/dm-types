module DataMapper
  module TypesFixtures

      class TShirt
        #
        # Behaviors
        #

        include ::DataMapper::Resource

        #
        # Properties
        #

        property :id,          Serial
        property :writing,     String
        property :has_picture, Boolean, :default => false
        property :picture,     Enum[:octocat, :fork_you, :git_down]

        property :color, Enum[:white, :black, :red, :orange, :yellow, :green, :cyan, :blue, :purple]
        property :size,  Flag[:xs, :small, :medium, :large, :xl, :xxl], :default => :xs
      end # Shirt
    end # TypesFixtures
end # DataMapper
