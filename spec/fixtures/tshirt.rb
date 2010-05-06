module DataMapper
  module Types
    module Fixtures

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
        property :picture,     Enum, :flags => [:octocat, :fork_you, :git_down]

        property :color, Enum, :flags => [:white, :black, :red, :orange, :yellow, :green, :cyan, :blue, :purple]
        property :size,  Flag, :flags => [:xs, :small, :medium, :large, :xl, :xxl]
      end # Shirt
    end # Fixtures
  end # Types
end # DataMapper
