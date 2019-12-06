require "rails_helper"

RSpec.describe Queries::User do
  include SeederHelper

  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})
  }

  describe "me" do
    before do
      prepare_query(
        "
        {
          me {
            name
          }
        }
        ")
    end

    context "when there's no current user" do
      it "is nil" do
        result = execute_graphql_query!
        fields = result["data"]["me"]
        expect(fields).to eq(nil)
      end
    end

    context "when there's a current user" do
      let(:user) do
        company = create_company
        company.employees.first.user
      end

      before do
        prepare_context(
          current_user: user
        )
      end

      it "shows the user's name" do
        result = execute_graphql_query!
        fields = result["data"]["me"]
        user_name = fields["name"]
        expect(user_name).to eq(user.name)
      end
    end
  end
end
