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
      # TODO - get from context? Preload at controller?
    end
  end
end
