require "rails_helper"

RSpec.describe Services::BaseService do
  module FormObjects
    module Dummy
      class DoSomething < FormObjects::BaseFormObject
        attr_accessor :dummy_input, :yet_another_dummy_input

        def initialize(dummy_input:, yet_another_dummy_input:)
        end

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
              process_value: 42,
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
      result = Services::Dummy::DoSomething.call(
        dummy_input: :bla, yet_another_dummy_input: :blabla
      )
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
    it "enforces the keyword arguments based on the form object" do
      expect do
        # No arguments supplied
        Services::Dummy::DoSomething.call
      end.to raise_error(ArgumentError)
    end

    it "attempts to validate form object by default" do
      result = Services::Dummy::DoSomething.call(
        dummy_input: :bla, yet_another_dummy_input: :blabla
      )
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

  describe "output" do
    subject do
      Services::Dummy::DoSomething.call(
        dummy_input: :bla, yet_another_dummy_input: :blabla
      )
    end

    it "returns a hash containing keys 'data' and 'errors'" do
      expect(subject.keys).to match_array(["data", "errors"])
    end

    it "returns the errors being contained in ActiveModel::Errors instance" do
      expect(subject.errors).to be_instance_of(ActiveModel::Errors)
    end
  end
end
