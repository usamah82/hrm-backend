# == Schema Information
#
# Table name: companies
#
#  id           :uuid             not null, primary key
#  name         :string           not null
#  country_code :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Company < ApplicationRecord
end
