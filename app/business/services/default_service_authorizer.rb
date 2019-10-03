module Services
  # Default authorizer for service objects
  class DefaultServiceAuthorizer
    # Authorizes a user against a given service object class
    #
    # By convention, the service object class alone indicates
    # - the intended action e.g (Services::User::CreateUser intends to perform 'create_user?' action)
    # - the policy class (Services::User::CreateUser would defer to Policies::UserPolicy)
    #
    # If no policy class is found, an exception is raised stating that such policy should be implemented.
    #
    # Else, the policy class is instantiated with the user and authorization is performed
    # against the intended action.
    def self.authorized?(user, service_object_class)
      action = action_to_authorize(service_object_class)
      domain_namespace = domain_namespace(service_object_class)
      policy_class = domain_policy_class(domain_namespace)

      raise Pundit::NotAuthorizedError,
        "Missing authorization policy. "\
        "Expected Policies::#{domain_namespace}Policy##{action.to_s} to be implemented, "\
        "else override the #authorize! hook" unless policy_class

      policy = policy_class.new(user, domain_namespace)
      policy.public_send(action)
    end

    # Converts a service object's name into a policy's action
    #
    def self.action_to_authorize(service_object_class)
      (service_object_class.name.demodulize.underscore + "?").to_sym
    end

    # Extracts the absolute, domain-related namespace
    # e.g Services::Domain::Subdomain::CreateSomething becomes Domain::Subdomain
    def self.domain_namespace(service_object_class)
      # Remove first and last namespace
      first, *domain_namespace = service_object_class.name.deconstantize.split("::")
      domain_namespace.join("::")
    end

    # Instantiates an instance of the policy based on domain and
    # namespacing conventions
    #
    def self.domain_policy_class(domain_namespace)
      policy_class_name = "Policies::" + domain_namespace + "Policy"

      policy_class =
        begin
          policy_class_name.constantize
        rescue
          nil
        end

      policy_class
    end
  end
end
