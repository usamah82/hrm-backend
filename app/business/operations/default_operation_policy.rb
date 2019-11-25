module Operations
  # Default authorization policy concerns for operations
  #
  # A domain can have multiple operations. The authorization to invoke
  # any one of these operations is contained in a single, domain-level policy class.
  #
  # By convention, the operation class alone indicates
  # - the intended action e.g (Operations::User::CreateUser intends to perform 'create_user?' action)
  # - the policy class (Operations::User::CreateUser would defer to Policies::UserPolicy)
  #
  class DefaultOperationPolicy
    # Returns the domain policy class for a given operation class
    #
    # e.g Operations::User::CreateUserOperation would defer to Policies::UserPolicy
    #
    # where domain is User
    #
    # Returns the class name if no such class can be constantized.
    def self.domain_policy_class(operation_class)
      domain_namespace = DomainHelper.to_domain_namespace(operation_class)

      policy_class_name = "Policies::" + domain_namespace + "Policy"

      policy_class =
        begin
          policy_class_name.constantize
        rescue
          policy_class_name
        end

      policy_class
    end

    # Converts a operation's class name into a domain's operation
    #
    # e.g Operations::User::CreateUserOperation to create_user
    #
    def self.domain_operation(operation_class)
      operation = DomainHelper.to_operation_class_name(operation_class).sub("Operation", "")
      (operation.underscore + "?").to_sym
    end

    # Returns back to the caller the pair of
    # - policy class
    # - domain action
    #
    # for the purpose of authorization.
    def self.authorization_components(operation_class)
      [
        domain_policy_class(operation_class),
        domain_operation(operation_class)
      ]
    end
  end
end
