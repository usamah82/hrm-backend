module FormObjects
  module User
    # Form object for CreateUser action
    class CreateUser < FormObjects::BaseFormObject
      attr_accessor :email, :name, :password, :password_confirmation

      validates :email, presence: true
      validates :email, length: { maximum: 255 }
      validates :email, format: { with: Devise.email_regexp }
      validates :name, presence: true
      validates :name, length: { maximum: 255 }
      validates :password, presence: true
      validates :password_confirmation, presence: true

      validate :matching_password_confirmation

      # Form initialization
      def initialize(email:, name:, password:, password_confirmation:)
        @email = email
        @name = name
        @password = password
        @password_confirmation = password_confirmation
      end

      private
        def matching_password_confirmation
          if password != password_confirmation
            errors.add(:password_confirmation)
          end
        end
    end
  end
end
