module Types
  module Root
    # Registration of query types
    class Query < Schema::BaseObject
      include Queries::User
    end
  end
end
