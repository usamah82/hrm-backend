module Types
  module Root
    # Registration of mutation types
    class Mutation < Schema::BaseObject
      include Mutations::User
      include Mutations::Company
    end
  end
end
