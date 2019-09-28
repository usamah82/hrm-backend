module Mutations
  # Mutation registrations for User domain
  module User
    # Inclusion of domain mutations
    def self.included(child_class)
      child_class.field :login_user, mutation: Mutations::User::LoginUser
      child_class.field :token_login_user, mutation: Mutations::User::TokenLoginUser
      child_class.field :logout_user, mutation: Mutations::User::LogoutUser
      child_class.field :update_user, mutation: Mutations::User::UpdateUser
      child_class.field :create_user, mutation: Mutations::User::CreateUser
      child_class.field :send_reset_password_instructions, mutation: Mutations::User::SendResetPasswordInstructions
      child_class.field :reset_password, mutation: Mutations::User::ResetPassword
      child_class.field :unlock_user, mutation: Mutations::User::UnlockUser
      child_class.field :resend_unlock_instructions, mutation: Mutations::User::ResendUnlockInstructions
    end
  end
end