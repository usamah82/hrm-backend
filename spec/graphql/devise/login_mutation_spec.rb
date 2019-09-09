require "rails_helper"

RSpec.describe GraphqlSchema do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation loginUser($email: String!, $password: String!){
        loginUser(email: $email, password: $password) {
          email
        }
      }
    ")
  }

  let(:password) { SecureRandom.uuid }

  describe "login_user" do
    context "when no user exists" do
      before {
        prepare_query_variables(
          email: Faker::Internet.email,
          password: password
        )
      }
      it "is nil" do
        expect(graphql!["data"]["loginUser"]).to eq(nil)
      end
    end


    context "when there's a matching user" do
      let(:user) { create(:user, email: Faker::Internet.email, password: password, password_confirmation: password) }

      before {
        prepare_query_variables(email: user.email, password: password)
      }

      it "returns user object" do
        user_email = graphql!["data"]["loginUser"]["email"]
        expect(user_email).to eq(user.email)
      end
    end
  end
end
