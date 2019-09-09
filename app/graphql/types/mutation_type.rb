module Types
  # MutationType
  class MutationType < Types::BaseObject
    ## LOGIN
    field :login_user, UserType, null: true do
      description "Login for users"
      argument :email, String, required: true
      argument :password, String, required: true
    end

    # Login
    def login_user(email:, password:)
      user = User.find_for_authentication(email: email)
      return nil if !user

      is_valid_for_auth = user.valid_for_authentication? {
        user.valid_password?(password)
      }
      is_valid_for_auth ? user : nil
    end

    ## TOKEN-LOGIN
    field :token_login_user, UserType, null: true do
      description "JWT token login"
    end

    # Token login
    def token_login_user
      context[:current_user]
    end

    ## LOGOUT
    field :logout_user, Boolean, null: true do
      description "Logout for users"
    end

    # Logout
    def logout_user
      if context[:current_user]
        context[:current_user].update(jti: SecureRandom.uuid)
        return true
      end
      false
    end

    field :update_user, UserType, null: true do
      description "Update user"
      argument :password, String, required: false
      argument :passwordConfirmation, String, required: false
    end

    # Update user
    def update_user(
        password: context[:current_user] ? context[:current_user].password : "",
        password_confirmation: context[:current_user] ? context[:current_user].password_confirmation : ""
      )
      user = context[:current_user]
      return nil if !user
      user.update!(
        password: password,
        password_confirmation: password_confirmation
      )
      user
    end

    field :create_user, UserType, null: true do
      description "Create user"
      argument :email, String, required: true
      argument :password, String, required: true
      argument :passwordConfirmation, String, required: true
      argument :name, String, required: true
    end

    # Sign up
    def create_user(email:, password:, password_confirmation:, name:)
      User.create(
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        name: name
      )
    end

    field :send_reset_password_instructions, Boolean, null: true do
      description "Send password reset instructions to users email"
      argument :email, String, required: true
    end

    # Send reset password instructions
    def send_reset_password_instructions(email:)
      user = User.find_by_email(email)
      return true if !user
      user.send_reset_password_instructions
      true
    end

    field :reset_password, Boolean, null: true do
      argument :password, String, required: true
      argument :passwordConfirmation, String, required: true
      argument :resetPasswordToken, String, required: true
    end

    # Reset password
    def reset_password(password:, password_confirmation:, reset_password_token:)
      user = User.with_reset_password_token(reset_password_token)
      return false if !user
      user.reset_password(password, password_confirmation)
    end

    # UNLOCK ACCOUNT
    field :unlock_user, Boolean, null: false do
      argument :unlockToken, String, required: true
    end

    # Unlock
    def unlock_user(unlock_token:)
      user = User.unlock_access_by_token(unlock_token)
      user.id
    end

    # RESEND UNLOCK INSTRUCTIONS
    field :resend_unlock_instructions, Boolean, null: false do
      argument :email, String, required: true
    end

    # Resend unlock instructions
    def resend_unlock_instructions(email:)
      user = User.find_by_email(email)
      return false if !user

      user.resend_unlock_instructions
    end
  end
end
