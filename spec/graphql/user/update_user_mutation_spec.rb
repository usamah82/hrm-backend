require "rails_helper"

RSpec.describe AppSchema do
  before {
    # reset vars and context
    prepare_query_variables({})
    prepare_context({})

    # set query
    prepare_query("
      mutation updateUser($input: UpdateUserInput! ){
        updateUser(input: $input) {
          user { email }
          errors
        }
      }
    ")
  }

  let (:password) { SecureRandom.uuid }

  describe "update" do
    context "when no user exists" do
      before {
        prepare_query_variables(
          input: {
            password: password,
            passwordConfirmation: password
          }
        )
      }
      it "returns nil user" do
        result = execute_graphql_query!
        fields = result["data"]["updateUser"]
        expect(fields["user"]).to eq(nil)
      end
    end

    context "when there's a matching user" do
      before {
        @current_user = create(
          :user,
          email: Faker::Internet.email,
          password: password,
          password_confirmation: password
        )
        prepare_context(current_user: @current_user)
      }

      let(:user) {
        @current_user
      }

      context "when password matches confirmation" do
        before {
          prepare_query_variables(
            input: {
              password: password,
              passwordConfirmation: password
            }
          )
        }

        it "returns user object" do
          result = execute_graphql_query!
          fields = result["data"]["updateUser"]
          user_email = fields["user"]["email"]

          expect(user_email).to eq(user.email)
        end
      end


      context "when password does not match confirmation" do
        before {
          prepare_query_variables(
            input: {
              password: password,
              passwordConfirmation: password + "1"
            }
          )
        }

        it "returns error" do
          result = execute_graphql_query!
          fields = result["data"]["updateUser"]

          expect(fields["errors"]).not_to eq nil
        end
      end
    end
  end
end
