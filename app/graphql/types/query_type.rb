module Types
  # QueryType
  class QueryType < BaseObject
    # ---- User ----
    field :me, Types::UserType, null: true do
      description "Returns the current user"
    end

    # Current user
    def me(demo: false)
      context[:current_user]
    end
  end
end
