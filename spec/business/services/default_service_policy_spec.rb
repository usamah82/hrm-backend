require "rails_helper"

RSpec.describe Services::DefaultServicePolicy do
  module Policies
    class DummyPolicy < Policies::BasePolicy
      def do_something?
        true
      end
    end
  end

  module Services
    module Dummy
      class DoSomething
      end
    end
  end

  module Services
    module AnotherDummy
      class DoSomething
      end
    end
  end


  describe ".domain_policy_class" do
    it "returns the expected domain policy class given the service object class" do
      expect(described_class.domain_policy_class(Services::Dummy::DoSomething)).to eq Policies::DummyPolicy
    end

    context "non-existent domain policy class" do
      it "returns the name of the expected domain policy glass" do
        expect(described_class.domain_policy_class(Services::AnotherDummy::DoSomething)).to eq(
          "Policies::AnotherDummyPolicy"
        )
      end
    end
  end

  describe ".domain_action" do
    it "returns the action given the service object class" do
      expect(described_class.domain_action(Services::Dummy::DoSomething)).to eq :do_something?
    end
  end

  describe ".authorization_components" do
    it "returns the pair domain policy class and domain action" do
      expect(
        described_class.authorization_components(Services::Dummy::DoSomething)
      ).to match_array([Policies::DummyPolicy, :do_something?])
    end
  end
end
