module Mutations
  module User
    # CreateUser mutation
    class CreateUser < Schema::BaseMutation
      null false

      description "Create user"

      argument :email, String, required: true
      argument :name, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true

      field :user, Types::User, null: true
      field :errors, [String], null: false

      # CreateUser mutation resolver
      def resolve(email:, name:, password:, password_confirmation:)
        user = ::User.create(
          email: email,
          password: password,
          password_confirmation: password_confirmation,
          name: name
        )

        { user: user, errors: user.errors.full_messages }
      end
    end
  end
end
