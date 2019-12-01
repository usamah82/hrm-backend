module Mutations
  # Mutation registrations for Company domain
  module Company
    # Inclusion of domain mutations
    def self.included(child_class)
      child_class.field :create_company, mutation: Mutations::Company::CreateCompany
    end
  end
end
