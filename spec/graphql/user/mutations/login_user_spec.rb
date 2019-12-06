require "rails_helper"

RSpec.describe Mutations::User::LoginUser do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation loginUser($input: LoginUserInput!){
        loginUser(input: $input) {
          user { email }
          errors
        }
      }
    ")
  }

  let(:password) { SecureRandom.uuid }

  describe "#resolve" do
    context "when no user exists" do
      before {
        prepare_query_variables(
          input: {
            email: Faker::Internet.email,
            password: password
          }
        )
      }
      it "is nil" do
        result = execute_graphql_query!
        fields = result["data"]["loginUser"]

        expect(fields["user"]).to eq(nil)
      end
    end


    context "when there's a matching user" do
      let(:user) { create(:user, email: Faker::Internet.email, password: password, password_confirmation: password) }

      before {
        prepare_query_variables(
          input: {
            email: user.email,
            password: password
          }
        )
      }

      it "returns user object" do
        result = execute_graphql_query!
        fields = result["data"]["loginUser"]
        user_email = fields["user"]["email"]

        expect(user_email).to eq(user.email)
      end
    end
  end
end
