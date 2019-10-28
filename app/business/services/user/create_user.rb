module Services
  module User
    # Creates a user
    class CreateUser < Services::BaseService
      private
        def process
          user = ::User.create(
            email: @form_object.email,
            password: @form_object.password,
            password_confirmation: @form_object.password_confirmation,
            name: @form_object.name
          )

          user
        end
    end
  end
end
