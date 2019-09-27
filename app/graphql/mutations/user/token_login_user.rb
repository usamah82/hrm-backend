module Mutations
  module User
    # TokenLoginUser mutation
    class TokenLoginUser < Schema::BaseMutation
      null false

      description "JWT token login"

      field :user, Types::User, null: true
      field :errors, [String], null: false

      # TokenLoginUser mutation resolver
      def resolve
        { user: context[:current_user], errors: [] }
      end
    end
  end
end
