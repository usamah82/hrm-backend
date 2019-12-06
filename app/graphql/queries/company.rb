module Queries
  # Query registrations for Company domain
  module Company
    # Inclusion of domain queries
    def self.included(child_class)
      child_class.field :company, Types::Company, null: true do
        description "Returns the company for the current user"
      end
    end

    # Current company
    def company
      context[:current_user].employee.company
    end
  end
end
