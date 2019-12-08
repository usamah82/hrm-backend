require "rails_helper"

RSpec.describe Mutations::User::CreateUser do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation createUser($input: CreateUserInput!){
        createUser(input: $input){
          user {
            email
            name
          }
          errors {
            path
            message
          }
        }
      }
    ")
  }

  describe "#resolve" do
    let(:email) { Faker::Internet.email }
    let(:name) { Faker::Name.name }

    before {
      prepare_query_variables(
        input: {
          email: email,
          name: name
        }
      )
    }

    it "returns user object" do
      result = execute_graphql_query!

      fields = result["data"]["createUser"]
      user_email = fields["user"]["email"]
      user_name = fields["user"]["name"]

      expect(user_email).to eq(email)
      expect(user_name).to eq(name)
    end
  end
end
