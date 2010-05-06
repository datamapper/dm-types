module DataMapper
  module Types
    module Fixtures
      class Ticket
        #
        # Behaviors
        #

        include DataMapper::Resource
        include DataMapper::Validations

        #
        # Properties
        #

        property :id,     Serial
        property :title,  String, :length => 255
        property :body,   Text
        property :status, Enum, :flags => [:unconfirmed, :confirmed, :assigned, :resolved, :not_applicable]
      end # Ticket
    end
  end
end
