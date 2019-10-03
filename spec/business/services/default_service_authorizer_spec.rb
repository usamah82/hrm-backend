require "rails_helper"

RSpec.describe Services::DefaultServiceAuthorizer do
  module Policies
    class DummyPolicy < Policies::BasePolicy
      def do_something?
        true
      end
    end
  end

  module Policies
    module Dummy
      class SubDummyPolicy < Policies::BasePolicy
        def do_something?
          true
        end
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
    module Dummy
      module SubDummy
        class DoSomething
        end
      end
    end
  end

  module Services
    module AnotherDummy
      class DoSomething
      end
    end
  end

  describe ".domain_namespace" do
    it "returns the full domain namespace, including subdomains" do
      expect(
        described_class.domain_namespace(Services::Dummy::SubDummy::DoSomething)
        ).to eq "Dummy::SubDummy"
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
      ).to eq Policies::DummyPolicy.new.do_something?
    end

    context "subdomains" do
      it "defers the authorization properly to the subdomain policy class" do
        expect(
          described_class.authorized?(Current.user, Services::Dummy::SubDummy::DoSomething)
        ).to eq Policies::Dummy::SubDummyPolicy.new.do_something?
      end
    end

  end
end
