require "rails_helper"

RSpec.describe GraphqlSchema do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation signUp(
        $email: String!, $password: String!, $passwordConfirmation: String!, $name: String!
      ){
        signUp(
          email: $email,
          password: $password,
          passwordConfirmation: $passwordConfirmation,
          name: $name
        ){
          email
        }
      }
    ")
  }

  describe "signUp" do
    let(:user) { build(:user) }

    before {
      prepare_query_variables(
        email: user.email,
        password: user.password,
        passwordConfirmation: user.password_confirmation,
        name: user.name
      )
    }

    it "returns user object" do
      user_email = graphql!["data"]["signUp"]["email"]
      expect(user_email).to eq(user.email)
    end
  end
end
