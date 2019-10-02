require "rails_helper"

RSpec.describe Services::DefaultServiceAuthorizer do
  module Policies
    class DummyPolicy
      def initialize(user, record)
      end

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
    it "returns the expected domain policy class given the domain name" do
      expect(described_class.domain_policy_class("Dummy")).to eq Policies::DummyPolicy
    end
  end

  describe ".action_to_authorize" do
    it "returns the action given the service object class" do
      expect(described_class.action_to_authorize(Services::Dummy::DoSomething)).to eq :do_something?
    end
  end

  describe ".authorized?" do
    context "no matching policy class" do
      it "raises an unauthorized exception" do
        expect do
          described_class.authorized?(Current.user, Services::AnotherDummy::DoSomething)
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    it "defers the authorization to the policy class" do
      expect(
        described_class.authorized?(Current.user, Services::Dummy::DoSomething)
      ).to eq Policies::DummyPolicy.new(dummy_user, dummy_record).do_something?
    end
  end
end
