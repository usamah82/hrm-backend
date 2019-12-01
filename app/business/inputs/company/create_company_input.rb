module Inputs
  module Company
    # Input for CreateCompany operation
    class CreateCompanyInput < Inputs::BaseInput
      attr_accessor :email, :name, :password, :password_confirmation

      validates :administrator_email, presence: true
      validates :administrator_email, format: { with: Devise.email_regexp }
      validates :administrator_name, presence: true

      validates :company_name, presence: true
      validates :country_code, presence: true # TODO - must be valid country code
    end
  end
end
