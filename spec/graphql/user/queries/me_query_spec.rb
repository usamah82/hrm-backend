require "rails_helper"

RSpec.describe Queries::User do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})
  }

  describe "me" do
    before {
      prepare_query("{
        me{
          name
        }
      }")
    }

    context "when there's no current user" do
      it "is nil" do
        expect(execute_graphql_query!["data"]["me"]).to eq(nil)
      end
    end

    context "when there's a current user" do
      before {
        prepare_context(
          current_user: create(:user, name: "John Doe")
        )
      }

      it "shows the user's name" do
        user_name = execute_graphql_query!["data"]["me"]["name"]
        expect(user_name).to eq("John Doe")
      end
    end
  end
end
