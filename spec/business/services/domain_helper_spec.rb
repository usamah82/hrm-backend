require "rails_helper"

RSpec.describe Services::DomainHelper do
  module Services
    module Dummy
      class DoSomething
      end
    end
  end

  module Services
    module Dummy
      module SubDummy
        class DoSomething < Services::BaseService
        end
      end
    end
  end

  describe ".to_domain_namespace" do
    it "returns the full domain namespace" do
      expect(
        described_class.to_domain_namespace(Services::Dummy::DoSomething)
        ).to eq "Dummy"
    end

    context "subdomain" do
      it "returns the full domain namespace, including subdomains" do
        expect(
          described_class.to_domain_namespace(Services::Dummy::SubDummy::DoSomething)
          ).to eq "Dummy::SubDummy"
      end
    end
  end

  describe ".to_service_object_class_name" do
    it "returns the service object class name without domain namespace" do
      expect(
        described_class.to_service_object_class_name(Services::Dummy::DoSomething)
        ).to eq "DoSomething"
    end
  end
end
