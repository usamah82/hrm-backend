module Types
  # User
  class User < Schema::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :token, String, null: false
    field :employee, Types::Employee, null: false
  end
end
