module Inputs
  module User
    # Form object for CreateUser action
    class CreateUser < Inputs::BaseInput
      attr_accessor :email, :name, :password, :password_confirmation
    end
  end
end
