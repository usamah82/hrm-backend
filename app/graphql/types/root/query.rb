module Types
  module Root
    # Registration of query types
    class Query < Schema::BaseObject
      include Queries::User
      include Queries::Company
    end
  end
end
