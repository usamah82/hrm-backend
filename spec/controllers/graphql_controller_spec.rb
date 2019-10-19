require "rails_helper"

RSpec.describe GraphqlController, type: :controller do

  login_user # access current user with @current_user

  describe "execute" do
    it "responds with a valid graphql response" do
      post :execute, params: { "query" => "{ me { email } }" }
      response_body = JSON.parse(response.body)
      expect(response_body).to eq(
        "data" => { "me" => { "email" => @current_user.email } }
      )
    end

    context "when wrong query params given" do
      it "should return with errors" do
        post :execute, params: { "query" => "{ wrong { email } }" }
        response_body = JSON.parse(response.body)
        expect(response_body["errors"]).to_not be nil
      end
    end

    # TODO better vairales test
    context "when using String variables" do
      it "should return with valid graphql response" do
        post :execute, params: { "query" => "{ me { email } }", "variables" => "{ \"Test\": \"Me\" }" }
        response_body = JSON.parse(response.body)
        expect(response_body).to eq(
          "data" => { "me" => { "email" => @current_user.email } }
        )
      end
    end

    context "when using empty String variables" do
      it "should return with valid graphql response" do
        post :execute, params: { "query" => "{ me { email } }", "variables" => "" }
        response_body = JSON.parse(response.body)
        expect(response_body).to eq(
          "data" => { "me" => { "email" => @current_user.email } }
        )
      end
    end

    context "when using Hash variables" do
      it "should return with valid graphql response" do
        post :execute, params: { "query" => "{ me { email } }", "variables" => { "Test" => "Me" } }
        response_body = JSON.parse(response.body)
        expect(response_body).to eq(
          "data" => { "me" => { "email" => @current_user.email } }
        )
      end
    end

    context "when variables are invalid" do

      it "should raise argument error" do
        expect {
          post :execute, params: { "query" => "{ me { email } }", "variables" => 12 }
        }.to raise_error(ArgumentError)
      end

      context "environment is development" do
        it "should call the local logger" do
          Rails.env = "development"
          expect {
            post :execute, params: { "query" => "{ me {  email } }", "variables" => 12 }
          }.not_to raise_error
          Rails.env = "test"
        end
      end
    end

  end
end
