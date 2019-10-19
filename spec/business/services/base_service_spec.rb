require "rails_helper"

RSpec.describe Services::BaseService do
  module FormObjects
    module Dummy
      class DoSomething < FormObjects::BaseFormObject
        def valid?
          true
        end
      end
    end
  end

  module Policies
    class DummyPolicy < Policies::BasePolicy
      def do_something?
        true
      end
    end
  end

  module Services
    module Dummy
      class DoSomething < Services::BaseService
        private
          def process
            {
              authorization_value: authorized?,
              validation_value: inputs_valid?,
            }
          end
      end
    end
  end

  module Services
    module DummyWithoutAuthPolicy
      class DoSomething < Services::BaseService
        private
          def process
          end
      end
    end
  end

  module Services
    module Dummy
      class DoSomethingWithoutFormObject < Services::BaseService
        private
          def process
          end

          # This bypasses the authorization, so we get to test validation instead
          def authorized?
            true
          end
      end
    end
  end

  describe "authorization" do
    it "attempts to authorize by default" do
      result = Services::Dummy::DoSomething.call
      expect(result.data.authorization_value).to eq true
    end

    context "no authorization policy" do
      it "raises exception" do
        expect do
          Services::DummyWithoutAuthPolicy::DoSomething.call
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe "validation" do
    it "attempts to validate form object by default" do
      result = Services::Dummy::DoSomething.call
      expect(result.data.validation_value).to eq true
    end

    context "no form object" do
      it "raises exception" do
        expect do
          Services::Dummy::DoSomethingWithoutFormObject.call
        end.to raise_error(NotImplementedError)
      end
    end
  end
end
