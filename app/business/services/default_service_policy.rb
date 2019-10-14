module Services
  # Default authorization policy concerns for service objects
  #
  # A domain can have multiple service objects. The authorization to invoke
  # any one of these service objects is contained in a single, domain-level policy class.
  #
  # By convention, the service object class alone indicates
  # - the intended action e.g (Services::User::CreateUser intends to perform 'create_user?' action)
  # - the policy class (Services::User::CreateUser would defer to Policies::UserPolicy)
  #
  class DefaultServicePolicy
    # Returns the domain policy class for a given service object class
    #
    # e.g Services::User::CreateUser would defer to Policies::UserPolicy
    #
    # where domain is User
    #
    # Returns the class name if no such class can be constantized.
    def self.domain_policy_class(service_object_class)
      domain_namespace = DomainHelper.to_domain_namespace(service_object_class)

      policy_class_name = "Policies::" + domain_namespace + "Policy"

      policy_class =
        begin
          policy_class_name.constantize
        rescue
          policy_class_name
        end

      policy_class
    end

    # Converts a service object's class name into a domain's action
    #
    # e.g Services::User::CreateUser to create_user
    #
    def self.domain_action(service_object_class)
      (service_object_class.name.demodulize.underscore + "?").to_sym
    end

    # Returns back to the caller the pair of
    # - policy class
    # - domain action
    #
    # for the purpose of authorization.
    def self.authorization_components(service_object_class)
      [
        domain_policy_class(service_object_class),
        domain_action(service_object_class)
      ]
    end
  end
end
