module Mutations
  module User
    # UpdateUser mutation
    class UpdateUser < Schema::BaseMutation
      null false

      description "Update user"

      argument :password, String, required: true
      argument :password_confirmation, String, required: true

      field :user, Types::User, null: true
      field :errors, [String], null: false

      # UpdateUser mutation resolver
      def resolve(password:, password_confirmation:)
        user = context[:current_user]

        return { user: nil, errors: [] } if !user

        user.update(
          password: password,
          password_confirmation: password_confirmation
        )

        { user: user, errors: user.errors.full_messages }
      end
    end
  end
end
