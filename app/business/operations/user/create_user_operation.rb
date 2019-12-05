module Operations
  module User
    # Creates a user
    class CreateUserOperation < Operations::BaseOperation
      private
        def process
          user = ::User.create!(
            email: @input.email,
            password: @input.password,
            password_confirmation: @input.password_confirmation,
            name: @input.name
          )

          user
        end
    end
  end
end
