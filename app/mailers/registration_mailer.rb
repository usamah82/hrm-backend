# Mailer to handler registration-related notifications
class RegistrationMailer < ApplicationMailer
  # Needed to generate the devise URLs
  include Devise::Controllers::UrlHelpers

  # Mails successful registration notification to the newly registered user
  def successful_registration
    @user = params[:user]
    @generated_password = params[:generated_password]

    mail(
      to: @user.email,
      subject: "User registration" # TODO - I18n
    )
  end
end
