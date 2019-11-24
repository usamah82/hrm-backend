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
      field :errors, [Types::MutationError], null: false

      # CreateUser mutation resolver
      def resolve(**args)
        result = Operations::User::CreateUserOperation.call(args)
        render_fields(user: result.data, errors: result.errors)
      end
    end
  end
end
