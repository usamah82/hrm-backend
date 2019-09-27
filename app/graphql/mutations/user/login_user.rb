module Mutations
  module User
    # LoginUser mutation
    class LoginUser < Schema::BaseMutation
      null false

      description "Login for users"

      argument :email, String, required: true
      argument :password, String, required: true

      field :user, Types::User, null: true
      field :errors, [String], null: false

      # LoginUser mutation resolver
      def resolve(email:, password:)
        user = ::User.find_for_authentication(email: email)
        return { user: nil, errors: [] } if !user

        is_valid_for_auth = user.valid_for_authentication? {
          user.valid_password?(password)
        }

        user = is_valid_for_auth ? user : nil
        { user: user, errors: [] }
      end
    end
  end
end
