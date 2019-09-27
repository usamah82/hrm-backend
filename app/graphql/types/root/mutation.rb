module Types
  module Root
    # Registration of mutation types
    class Mutation < Schema::BaseObject
      field :login_user, mutation: Mutations::User::LoginUser
      field :token_login_user, mutation: Mutations::User::TokenLoginUser
      field :logout_user, mutation: Mutations::User::LogoutUser
      field :update_user, mutation: Mutations::User::UpdateUser
      field :create_user, mutation: Mutations::User::CreateUser
      field :send_reset_password_instructions, mutation: Mutations::User::SendResetPasswordInstructions
      field :reset_password, mutation: Mutations::User::ResetPassword
      field :unlock_user, mutation: Mutations::User::UnlockUser
      field :resend_unlock_instructions, mutation: Mutations::User::ResendUnlockInstructions
    end
  end
end
