module Mutations
  module User
    # ResendUnlockInstructions mutation
    class ResendUnlockInstructions < Schema::BaseMutation
      null false

      description "Resend unlock instructions to user's email"

      argument :email, String, required: true

      field :unlock_instructions_sent, Boolean, null: false
      field :errors, [String], null: false

      # ResendUnlockInstructions mutation resolver
      def resolve(email:)
        user = ::User.find_by_email(email)

        user.resend_unlock_instructions if user

        { unlock_instructions_sent: true, errors: [] }
      end
    end
  end
end
