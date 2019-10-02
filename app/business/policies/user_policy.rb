module Policies
  # Policies for User domain
  class UserPolicy < Policies::BasePolicy
    # Determines if a user can be created
    def create_user?
      true
    end
  end
end
