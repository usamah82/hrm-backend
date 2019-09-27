module Mutations
  module User
    # UnlockUser mutation
    class UnlockUser < Schema::BaseMutation
      null false

      description "Unlock user"

      argument :unlock_token, String, required: true

      field :user_unlocked, Boolean, null: false
      field :errors, [String], null: false

      # UnlockUser mutation resolver
      def resolve(unlock_token:)
        user = ::User.unlock_access_by_token(unlock_token)
        { user_unlocked: !user.errors.any?, errors: user.errors.full_messages }
      end
    end
  end
end
