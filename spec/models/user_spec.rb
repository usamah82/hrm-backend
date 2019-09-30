# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  name                   :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  jti                    :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require "rails_helper"

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_most(255) }
  it { should validate_presence_of(:email) }
  it { should validate_length_of(:email).is_at_most(255) }
  it { is_expected.to allow_value("email@address.foo").for(:email) }
  it { is_expected.to_not allow_value("email").for(:email) }
  it { is_expected.to_not allow_value("email@domain").for(:email) }
  it { is_expected.to_not allow_value("email@domain.").for(:email) }
  it { is_expected.to_not allow_value("email@domain.a").for(:email) }
end
