module Types
  # User
  class Company < Schema::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :country_code, String, null: true
    field :employees, Types::Employee.connnection_type, null: false
  end
end
