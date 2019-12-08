require "rails_helper"

describe Operations::User::CreateUserOperation do
  it "creates a new user" do
    args = {
      email: Faker::Internet.email,
      name: Faker::Name.name
    }

    result = described_class.(args)

    expect(result.data).to be_instance_of User
    expect(result.data.persisted?).to eq true
    expect(result.data.email).to eq args[:email]
    expect(result.data.name).to eq args[:name]
  end
end
