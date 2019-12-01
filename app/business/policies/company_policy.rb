module Policies
  # Policies for Company domain
  class CompanyPolicy < Policies::BasePolicy
    # Determines if a company can be created
    def create_company?
      true
    end
  end
end
