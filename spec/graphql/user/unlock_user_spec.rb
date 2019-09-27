require "rails_helper"

RSpec.describe AppSchema do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation unlockUser($input: UnlockUserInput!){
        unlockUser(input: $input){
          userUnlocked
          errors
        }
      }
    ")
  }

  let(:password) { SecureRandom.uuid }

  describe "unlockUser" do
    context "when no user exists with that token" do
      before {
        prepare_query_variables(
          input: {
            unlockToken: "faked"
          }
        )
      }

      it "returns false" do
        result = execute_graphql_query!
        fields = result["data"]["unlockUser"]

        expect(fields["userUnlocked"]).to be false
      end
    end

    context "when user exists" do
      before {
        @user = create(:user, unlock_token: SecureRandom.uuid)
        prepare_query_variables(
          input: {
            unlockToken: @user.unlock_token
          }
        )

        # Mock get user with token from devise
        allow(User).to receive(:unlock_access_by_token) { @user }
      }

      let(:user) { @user }

      it "returns true" do
        result = execute_graphql_query!
        fields = result["data"]["unlockUser"]

        expect(fields["userUnlocked"]).to be true
      end
    end
  end
end
