module Services
  module User
    # Creates a user
    class CreateUser < Services::BaseService
      private
        def process
          user = ::User.create(
            email: @args[:email],
            password: @args[:password],
            password_confirmation: @args[:password_confirmation],
            name: @args[:name]
          )

          user
        end

        def inputs_valid?
          true
        end
    end
  end
end
