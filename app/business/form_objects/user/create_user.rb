module FormObjects
  module User
    # Form object for CreateUser action
    class CreateUser < FormObjects::BaseFormObject
      attr_accessor :email, :name, :password, :password_confirmation
    end
  end
end
