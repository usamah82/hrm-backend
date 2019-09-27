module Mutations
  module User
    # LogoutUser mutation
    class LogoutUser < Schema::BaseMutation
      null false

      description "Logout for users"

      field :user_logged_out, Boolean, null: false
      field :errors, [String], null: false

      # LogoutUser mutation resolver
      def resolve
        user_logged_out =
          if context[:current_user]
            context[:current_user].update(jti: SecureRandom.uuid)
            true
          else
            false
          end

        { user_logged_out: user_logged_out, errors: [] }
      end
    end
  end
end
