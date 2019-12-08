module Inputs
  module User
    # Input for CreateUser operation
    class CreateUserInput < Inputs::BaseInput
      attr_accessor :email, :name, :password, :password_confirmation

      validates :email, presence: true
      validates :email, format: { with: Devise.email_regexp }
      validates :name, presence: true
    end
  end
end
