require "rails_helper"

describe Operations::User::CreateUserOperation do
  it "creates a new user" do
    args = {
      email: Faker::Internet.email,
      name: Faker::Name.name,
      password: "thisismysupersecurepassword",
      password_confirmation: "thisismysupersecurepassword"
    }

    result = described_class.call(args)

    expect(result.data).to be_instance_of User
    expect(result.data.persisted?).to eq true
    expect(result.data.email)
  end
end
