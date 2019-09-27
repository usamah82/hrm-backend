module Mutations
  module User
    # SendResetPasswordInstructions mutation
    class SendResetPasswordInstructions < Schema::BaseMutation
      null false

      description "Send password reset instructions to user's email"

      argument :email, String, required: true

      field :reset_password_instructions_sent, Boolean, null: false
      field :errors, [String], null: false

      # SendResetPasswordInstructions mutation resolver
      def resolve(email:)
        user = ::User.find_by_email(email)

        user.send_reset_password_instructions if user

        { reset_password_instructions_sent: true, errors: [] }
      end
    end
  end
end
