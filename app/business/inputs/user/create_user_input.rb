module Inputs
  module User
    # Input for CreateUser operation
    class CreateUserInput < Inputs::BaseInput
      attr_accessor :email, :name, :password, :password_confirmation

      validates :email, presence: true
      validates :email, format: { with: Devise.email_regexp }
      validates :name, presence: true
      validates :password, presence: true
      validates :password_confirmation, presence: true

      validate :matching_password_confirmation

      private
        def matching_password_confirmation
          if password != password_confirmation
            errors.add(:password_confirmation)
          end
        end
    end
  end
end
