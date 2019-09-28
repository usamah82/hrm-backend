require "rails_helper"

RSpec.describe Mutations::User::TokenLoginUser do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation tokenLoginUser($input: TokenLoginUserInput!) {
        tokenLoginUser(input: $input) {
          user { email }
          errors
        }
      }
    ")

    prepare_query_variables(input: {})
  }

  let(:password) { SecureRandom.uuid }

  describe "#resolve" do
    context "when no user exists" do
      it "is nil" do
        result = execute_graphql_query!
        fields = result["data"]["tokenLoginUser"]

        expect(fields["user"]).to eq(nil)
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

      it "returns user object" do
        result = execute_graphql_query!
        fields = result["data"]["tokenLoginUser"]
        user_email = fields["user"]["email"]

        expect(user_email).to eq(user.email)
      end
    end
  end
end
