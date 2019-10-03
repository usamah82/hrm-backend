module Policies
  # Base policy for all the deriving policies, where by default access is restricted.
  class BasePolicy
    attr_reader :user, :record

    # Initializes the policy with user and record to authorize against
    #
    # Both the user and record arguments are optional, since there can be policies
    # - not requiring any current user (e.g true / false by default)
    # - not having an existing resource to authorize against e.g to create a new user
    def initialize(user = nil, record = nil)
      @user = user
      @record = record
    end

    # Scope class to determine the restrictions against domain models
    class Scope
      attr_reader :user, :scope

      # Initializes the scope with user and the current scope / list of domain models
      def initialize(user = nil, scope)
        @user = user
        @scope = scope
      end

      # Resolves the final scope
      def resolve
        scope.all
      end
    end
  end
end
