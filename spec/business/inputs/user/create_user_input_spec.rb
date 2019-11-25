require "rails_helper"

describe Inputs::User::CreateUserInput do
  describe "password_confirmation" do
    context "matches password" do
      it "is valid" do
        form = described_class.new(
          email: Faker::Internet.email,
          name: Faker::Name.name,
          password: "thisismysupersecurepassword",
          password_confirmation: "thisismysupersecurepassword"
        )

        expect(form.valid?).to eq true
      end
    end

    context "doesn't match password" do
      it "is invalid" do
        form = described_class.new(
          email: Faker::Internet.email,
          name: Faker::Name.name,
          password: "thisismysupersecurepassword",
          password_confirmation: "thisdoesntmatchthepasswordatall"
        )

        expect(form.valid?).to eq false
        expect(form.errors[:password_confirmation]).not_to be_empty
      end
    end
  end
end
