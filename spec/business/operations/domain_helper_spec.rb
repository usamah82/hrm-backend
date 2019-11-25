require "rails_helper"

RSpec.describe Operations::DomainHelper do
  module Operations
    module Dummy
      class DoSomethingOperation < Operations::BaseOperation
      end
    end
  end

  module Operations
    module Dummy
      module SubDummy
        class DoSomethingOperation < Operations::BaseOperation
        end
      end
    end
  end

  describe ".to_domain_namespace" do
    it "returns the full domain namespace" do
      expect(
        described_class.to_domain_namespace(Operations::Dummy::DoSomethingOperation)
        ).to eq "Dummy"
    end

    context "subdomain" do
      it "returns the full domain namespace, including subdomains" do
        expect(
          described_class.to_domain_namespace(Operations::Dummy::SubDummy::DoSomethingOperation)
          ).to eq "Dummy::SubDummy"
      end
    end
  end

  describe ".to_operation_class_name" do
    it "returns the operation class name without domain namespace" do
      expect(
        described_class.to_operation_class_name(Operations::Dummy::DoSomethingOperation)
        ).to eq "DoSomethingOperation"
    end
  end
end
