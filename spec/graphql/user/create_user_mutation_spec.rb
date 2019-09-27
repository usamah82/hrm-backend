require "rails_helper"

RSpec.describe AppSchema do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation createUser($input: CreateUserInput!){
        createUser(input: $input){
          user { email }
          errors
        }
      }
    ")
  }

  describe "createUser" do
    let(:user) { build(:user) }

    before {
      prepare_query_variables(
        input: {
          email: user.email,
          password: user.password,
          passwordConfirmation: user.password_confirmation,
          name: user.name
        }
      )
    }

    it "returns user object" do
      result = execute_graphql_query!
      fields = result["data"]["createUser"]
      user_email = fields["user"]["email"]

      expect(user_email).to eq(user.email)
    end
  end
end
