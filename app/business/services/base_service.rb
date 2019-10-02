module Services
  # Base class for service object implementations.
  # It basically ensures that each service object adheres to
  # SRP - Single Responsibility Principle, by only exposing a single
  # '.call' method to invoke the service object.
  #
  # However it does expose various hooks for validation and result
  # rendering, to be overriden by the deriving service objects.
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
    # validation and data / errors rendering, however by default
    # they do not have to be implemented unless necessary.
    #
    # This method returns a hash with the following keys:
    # - :data, which can be anything
    # - :errors, which ideally should be an {Array}
    #
    # It is up to the implementer to supply the values for :data and :errors.
    #
    # @return [Hashie::Mash] A {Hashie::Mash} consisting of keys :data and :errors
    def call
      if inputs_valid?
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
        raise NotImplementedError("#process instance method must be implemented")
      end

      # Hook for validation
      def inputs_valid?
        true
      end

      # Hook to render data
      def render_data
        @data
      end

      # Hook to render errors
      def render_errors
        []
      end
  end
end
