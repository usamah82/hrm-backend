module Queries
  # Query registrations for User domain
  module User
    # Inclusion of domain queries
    def self.included(child_class)
      child_class.field :me, Types::User, null: true do
        description "Returns the current user"
      end
    end

    # Current user
    def me(demo: false)
      context[:current_user]
    end
  end
end