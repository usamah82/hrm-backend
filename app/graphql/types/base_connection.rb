module Types
  # Base Connection Class
  class BaseConnection < GraphQL::Types::Relay::BaseConnection
    field :total_count, Integer, "Total # of objects returned from this query", null: false

    # Returns the size of nodes for the connection
    def total_count
      object.nodes.size
    end
  end
end
