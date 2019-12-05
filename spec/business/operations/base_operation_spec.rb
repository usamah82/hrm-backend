require "rails_helper"

RSpec.describe Operations::BaseOperation do
  module Inputs
    module Dummy
      class DoSomethingInput < Inputs::BaseInput
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

  module Operations
    module Dummy
      class DoSomethingOperation < Operations::BaseOperation
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

  module Operations
    module DummyWithoutAuthPolicy
      class DoSomethingOperation < Operations::BaseOperation
        private
          def process
          end
      end
    end
  end

  module Operations
    module Dummy
      class DoSomethingWithoutInputOperation < Operations::BaseOperation
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
      result = Operations::Dummy::DoSomethingOperation.(
        dummy_input: :bla, yet_another_dummy_input: :blabla
      )
      expect(result.data.authorization_value).to eq true
    end

    context "no authorization policy" do
      it "raises exception" do
        expect do
          Operations::DummyWithoutAuthPolicy::DoSomethingOperation.()
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe "validation" do
    it "enforces the keyword arguments based on the input" do
      expect do
        # No arguments supplied
        Operations::Dummy::DoSomethingOperation.()
      end.to raise_error(ArgumentError)
    end

    it "attempts to validate input by default" do
      result = Operations::Dummy::DoSomethingOperation.(
        dummy_input: :bla, yet_another_dummy_input: :blabla
      )
      expect(result.data.validation_value).to eq true
    end

    context "no input" do
      it "raises exception" do
        expect do
          Operations::Dummy::DoSomethingWithoutInputOperation.()
        end.to raise_error(NotImplementedError)
      end
    end
  end

  describe "output" do
    subject do
      Operations::Dummy::DoSomethingOperation.(
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
