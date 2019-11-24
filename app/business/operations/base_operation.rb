module Operations
  # Base class for operation implementations.
  # It basically ensures that each operation adheres to
  # SRP - Single Responsibility Principle, by only exposing a single
  # '.call' method to invoke the operation.
  #
  # However it does expose various hooks for validation and result
  # rendering, to be overriden by the deriving operations.
  #
  # As per best practice, operation should be secured and flawless
  # by default - hence any operation implementation must implement
  #
  # - authorization
  # - validation
  # - actual processing
  #
  # Having all these concerns built into the operation ensures
  # proper consolidation and good reusability, which is important as
  # operations are the only ways of interacting with the application
  # state.
  #
  # If those concerns are not applicable, the default hooks can be overridden
  # to become permissive instead of restrictive e.g '#inputs_valid?' always returns true
  class BaseOperation
    # Main entrypoint to the operation
    #
    # @param args [Hash] list of named arguments to be consumed by the operation
    #
    # Refer to {#call}
    def self.call(**args)
      new(args).call
    end

    # Initializes the operation
    #
    # @param (see {call})
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
      # The heavy lifting is done within this method. All operations must at the very
      # minimum implement this method
      #
      # @return [Object] Ideally the output (data) from the processing
      def process
        raise NotImplementedError("The instance method '#process' must be implemented for the operation")
      end

      # Hook for authorization
      #
      # By default it looks for corresponding policy given the operation class
      #
      # For example, if the operation is Operations::User::CreateUser, it will check for
      # Policies::User#create_user?
      #
      # If the policy is not available, an exception is raised.
      #
      # @return [Boolean] True if current user is authorized
      def authorized?
        domain_policy_class, domain_operation = DefaultOperationPolicy.authorization_components(self.class)

        raise Pundit::NotAuthorizedError,
          "Missing authorization policy. "\
          "Expected #{domain_policy_class} to be implemented, "\
          "else override the #authorized? hook" unless domain_policy_class.is_a? Class

        # TODO - figure out scoping of resources / records. Currently we pass a symbol of the action
        @policy = domain_policy_class.new(Current.user, domain_operation)
        @policy.public_send(domain_operation)
      end


      # Hook for validation
      #
      # By default the inputs to the operation are instantiated into an input object, which then
      # validates the inputs.
      #
      # @return [Boolean] True if the inputs, by default contained in an input object, are valid
      def inputs_valid?
        input_class = DefaultOperationInput.input_class(self.class)

        raise NotImplementedError,
          "Missing operation input implementation. "\
          "Expected #{input_class} to be implemented, "\
          "else override the #inputs_valid? hook" unless input_class.is_a? Class

        @input = input_class.new(@args)
        @input.valid?
      end

      # Hook to render data
      #
      # By default it renders the outcome of the {#process} method
      #
      # @return [Object] The outcome of the {#process} method
      def render_data
        @data
      end

      # Hook to render errors
      #
      # By default it renders the errors of input object
      #
      # @return [ActiveRecord::Errors]
      def render_errors
        @input.errors
      end
  end
end
