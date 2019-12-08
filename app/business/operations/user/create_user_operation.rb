module Operations
  module User
    # Creates a user
    class CreateUserOperation < Operations::BaseOperation
      private
        def process
          generated_password = Devise.friendly_token.first(8)

          user = ::User.create!(
            email: @input.email,
            password: generated_password,
            password_confirmation: generated_password,
            name: @input.name
          )

          # TODO!!!
          # RegistrationMailer.successful_registration(
          #   user, generated_password
          # ).deliver_later

          user
        end
    end
  end
end
