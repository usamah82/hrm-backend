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
        result = execute_graphql_query!
        fields = result["data"]["me"]
        expect(fields).to eq(nil)
      end
    end

    context "when there's a current user" do
      before {
        prepare_context(
          current_user: create(:user, name: "John Doe")
        )
      }

      it "shows the user's name" do
        result = execute_graphql_query!
        fields = result["data"]["me"]
        user_name = fields["name"]
        expect(user_name).to eq("John Doe")
      end
    end
  end
end
