# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  first_name             :string           default(""), not null
#  last_name              :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  jti                    :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#

# User
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include Tokenizable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :devise,
         :validatable,
         :lockable,
         :trackable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  # - RELATIONS
  # -

  # - VALIDATIONS
  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, format: { with: Regex::Email::VALIDATE }
  validates :name, presence: true
  validates :name, length: { maximum: 255 }

  # Send mail through activejob
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
