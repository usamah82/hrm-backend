require "rails_helper"

RSpec.describe AppSchema do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation resendUnlockInstructions($input: ResendUnlockInstructionsInput!){
        resendUnlockInstructions(input: $input) {
          unlockInstructionsSent
          errors
        }
      }
    ")
  }

  describe "resendUnlockInstructions" do
    context "when no user exists" do
      before {
        prepare_query_variables(
          input: {
            email: Faker::Internet.email
          }
        )
      }

      it "returns always true" do
        result = execute_graphql_query!
        fields = result["data"]["resendUnlockInstructions"]

        expect(fields["unlockInstructionsSent"]).to be true
      end
    end

    context "when user exists" do
      before {
        @user = create(:user)
        prepare_query_variables(
          input: {
            email: @user.email,
          }
        )
      }

      let(:user) { @user }

      it "returns true" do
        result = execute_graphql_query!
        fields = result["data"]["resendUnlockInstructions"]

        expect(fields["unlockInstructionsSent"]).to be true
      end

      it "calls send_reset_password_instructions on user" do
        allow_any_instance_of(User).to receive(:send_unlock_instructions)
        execute_graphql_query!
      end
    end
  end
end
