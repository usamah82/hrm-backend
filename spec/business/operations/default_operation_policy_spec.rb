require "rails_helper"

RSpec.describe Operations::DefaultOperationPolicy do
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
      end
    end
  end

  module Operations
    module AnotherDummy
      class DoSomethingOperation < Operations::BaseOperation
      end
    end
  end


  describe ".domain_policy_class" do
    it "returns the expected domain policy class given the operation class" do
      expect(described_class.domain_policy_class(Operations::Dummy::DoSomethingOperation)).to eq(
        Policies::DummyPolicy
      )
    end

    context "non-existent domain policy class" do
      it "returns the name of the expected domain policy class" do
        expect(described_class.domain_policy_class(Operations::AnotherDummy::DoSomethingOperation)).to eq(
          "Policies::AnotherDummyPolicy"
        )
      end
    end
  end

  describe ".domain_operation" do
    it "returns the action given the operation class" do
      expect(described_class.domain_operation(Operations::Dummy::DoSomethingOperation)).to eq :do_something?
    end
  end

  describe ".authorization_components" do
    it "returns the pair domain policy class and domain action" do
      expect(
        described_class.authorization_components(Operations::Dummy::DoSomethingOperation)
      ).to match_array([Policies::DummyPolicy, :do_something?])
    end
  end
end
