# == Schema Information
#
# Table name: employees
#
#  id         :uuid             not null, primary key
#  company_id :bigint           not null
#  user_id    :bigint           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Employee model
class Employee < ApplicationRecord
  belongs_to :company
  belongs_to :user
end
