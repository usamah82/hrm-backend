require "rails_helper"

RSpec.describe Services::DefaultServiceFormObject do
  module FormObjects
    module Dummy
      class DoSomething < FormObjects::BaseFormObject
      end
    end
  end

  module Services
    module Dummy
      class DoSomething < Services::BaseService
      end
    end
  end

  module Services
    module AnotherDummy
      class DoSomething < Services::BaseService
      end
    end
  end


  describe ".form_object_class" do
    it "returns the expected form object class given the service object class" do
      expect(described_class.form_object_class(Services::Dummy::DoSomething)).to eq FormObjects::Dummy::DoSomething
    end

    context "non-existent form object class" do
      it "returns the name of the expected domain policy glass" do
        expect(described_class.form_object_class(Services::AnotherDummy::DoSomething)).to eq(
          "FormObjects::AnotherDummy::DoSomething"
        )
      end
    end
  end
end
