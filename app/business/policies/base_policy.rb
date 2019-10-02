module Policies
  # Base policy for all the deriving policies, where by default access is restricted.
  class BasePolicy
    attr_reader :user, :record

    # Initializes the policy with user and record to authorize against
    def initialize(user, record)
      @user = user
      @record = record
    end

    # Scope class to determine the restrictions against domain models
    class Scope
      attr_reader :user, :scope

      # Initializes the scope with user and the current scope / list of domain models
      def initialize(user, scope)
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
