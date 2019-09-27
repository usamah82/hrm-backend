module Mutations
  module User
    # ResetPassword mutation
    class ResetPassword < Schema::BaseMutation
      null false

      description "Resets user's password"

      argument :password, String, required: true
      argument :password_confirmation, String, required: true
      argument :reset_password_token, String, required: true

      field :password_reset, Boolean, null: false
      field :errors, [String], null: false

      # ResetPassword mutation resolver
      def resolve(password:, password_confirmation:, reset_password_token:)
        user = ::User.with_reset_password_token(reset_password_token)
        return { password_reset: false, errors: [] } if !user

        user.reset_password(password, password_confirmation)
        { password_reset: !user.errors.any?, errors: user.errors.full_messages }
      end
    end
  end
end
