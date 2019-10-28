module Services
  # Base class for service object implementations.
  # It basically ensures that each service object adheres to
  # SRP - Single Responsibility Principle, by only exposing a single
  # '.call' method to invoke the service object.
  #
  # However it does expose various hooks for validation and result
  # rendering, to be overriden by the deriving service objects.
  #
  # As per best practice, service object should be secured and flawless
  # by default - hence any service object implementation must implement
  #
  # - authorization
  # - validation
  # - actual processing
  #
  # Having all these concerns built into the service object ensures
  # proper consolidation and good reusability, which is important as
  # service objects are the only ways of interacting with the application
  # state.
  #
  # If those concerns are not applicable, the default hooks can be overridden
  # to become permissive instead of restrictive e.g '#inputs_valid?' always returns true
  class BaseService
    # Main entrypoint to the service object
    def self.call(**args)
      new(args).call
    end

    # Initializes the service object
    def initialize(**args)
      @args = args
    end

    # The actual instance method that's invoked. There's hooks for
    # authorization, validation and data / errors rendering.
    #
    # This method returns a {::Hashie::Mash} with the following keys:
    # - :data, which can be anything
    # - :errors, which ideally should be an {::Array}
    #
    # It is up to the implementer to supply the values for :data and :errors.
    #
    # @return [Hashie::Mash] A {::Hashie::Mash} consisting of keys :data and :errors
    def call
      if authorized? && inputs_valid?
        @data = process
      end

      Hashie::Mash.new(data: render_data, errors: render_errors)
    end

    private
      # The heavy lifting is done within this method. All service objects must at the very
      # minimum implement this method
      #
      # @return Ideally the output (data) from the processing
      def process
        raise NotImplementedError("The instance method '#process' must be implemented for the service object")
      end

      # Hook for authorization
      #
      # By default it looks for corresponding policy given the service object class
      #
      # For example, if the service object is Services::User::CreateUser, it will check for
      # Policies::User#create_user?
      #
      # If the policy is not available, an exception is raised.
      def authorized?
        domain_policy_class, domain_action = DefaultServicePolicy.authorization_components(self.class)

        raise Pundit::NotAuthorizedError,
          "Missing authorization policy. "\
          "Expected #{domain_policy_class} to be implemented, "\
          "else override the #authorized? hook" unless domain_policy_class.is_a? Class

        # TODO - figure out scoping of resources / records. Currently we pass a symbol of the action
        policy = domain_policy_class.new(Current.user, domain_action)
        policy.public_send(domain_action)
      end


      # Hook for validation
      def inputs_valid?
        form_object_class = DefaultServiceFormObject.form_object_class(self.class)

        raise NotImplementedError,
          "Missing service form object implementation. "\
          "Expected #{form_object_class} to be implemented, "\
          "else override the #inputs_valid? hook" unless form_object_class.is_a? Class

        @form_object = form_object_class.new(@args)
        @form_object.valid?
      end

      # Hook to render data
      #
      # By default it renders the outcome of the `process` method
      def render_data
        @data
      end

      # Hook to render errors
      #
      # By default it renders the errors of the `@form_object`
      def render_errors
        @form_object.errors
      end
  end
end
