module Types
  module Root
    # Registration of mutation types
    class Mutation < Schema::BaseObject
      include Mutations::User
    end
  end
end
