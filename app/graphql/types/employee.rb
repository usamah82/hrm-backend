module Types
  # Employee
  class Employee < Schema::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :company, Types::Company, null: false
    field :user, Types::User, null: false
  end
end
