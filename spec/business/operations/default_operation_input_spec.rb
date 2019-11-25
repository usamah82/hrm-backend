require "rails_helper"

RSpec.describe Operations::DefaultOperationInput do
  module Inputs
    module Dummy
      class DoSomethingInput < Inputs::BaseInput
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


  describe ".input_class" do
    it "returns the expected input class given the operation class" do
      expect(described_class.input_class(Operations::Dummy::DoSomethingOperation)).to eq(
        Inputs::Dummy::DoSomethingInput
      )
    end

    context "non-existent input class" do
      it "returns the name of the expected input class" do
        expect(described_class.input_class(Operations::AnotherDummy::DoSomethingOperation)).to eq(
          "Inputs::AnotherDummy::DoSomethingInput"
        )
      end
    end
  end
end
