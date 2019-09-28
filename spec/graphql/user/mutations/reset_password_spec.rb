require "rails_helper"

RSpec.describe Mutations::User::ResetPassword do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation resetPassword($input: ResetPasswordInput!){
        resetPassword(input: $input){
          passwordReset
          errors
        }
      }
    ")
  }

  let(:password) { SecureRandom.uuid }

  describe "#resolve" do
    context "when no user exists with that token" do
      before {
        prepare_query_variables(
          input: {
            password: password,
            passwordConfirmation: password,
            resetPasswordToken: "faked"
          }
        )
      }

      it "returns false" do
        result = execute_graphql_query!
        fields = result["data"]["resetPassword"]

        expect(fields["passwordReset"]).to be false
      end
    end

    context "when user exists" do
      before {
        @user = create(:user, reset_password_token: SecureRandom.uuid)
        prepare_query_variables(
          input: {
            password: password,
            passwordConfirmation: password,
            resetPasswordToken: @user.reset_password_token
          }
        )

        # Mock get user with token from devise
        allow(User).to receive(:with_reset_password_token) { @user }
      }

      let(:user) { @user }

      it "returns true" do
        result = execute_graphql_query!
        fields = result["data"]["resetPassword"]

        expect(fields["passwordReset"]).to be true
      end

      it "calls reset_password on user" do
        expect(user).to receive(:reset_password).with(password, password)
        execute_graphql_query!
      end

      context "when password does NOT match confirmation" do
        it "returns false" do
          prepare_query_variables(
            input: {
              password: password,
              passwordConfirmation: password + "1",
              resetPasswordToken: @user.reset_password_token
            }
          )

          result = execute_graphql_query!
          fields = result["data"]["resetPassword"]

          expect(fields["passwordReset"]).to be false
        end
      end
    end
  end
end
