require "rails_helper"

RSpec.describe AppSchema do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation logoutUser($input: LogoutUserInput!) {
        logoutUser(input: $input) {
          userLoggedOut
          errors
        }
      }
    ")

    prepare_query_variables(input: {})
  }

  let(:password) { SecureRandom.uuid }

  describe "logout" do
    context "when no user exists" do
      it "returns false" do
        result = execute_graphql_query!
        fields = result["data"]["logoutUser"]

        expect(fields["userLoggedOut"]).to be false
      end
    end


    context "when there's a matching user" do
      before {
        @current_user = create(:user, email: Faker::Internet.email, password: password, password_confirmation: password)
        prepare_context(current_user: @current_user)
      }

      let(:user) {
        @current_user
      }

      it "returns true and resets the user's JTI" do
        jti_before = user.jti

        result = execute_graphql_query!
        fields = result["data"]["logoutUser"]

        expect(fields["userLoggedOut"]).to be true

        user.reload
        expect(user.jti).not_to eq jti_before
      end
    end
  end
end
