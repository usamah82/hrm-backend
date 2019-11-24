module Operations
  # Default input concerns for operations
  class DefaultOperationInput
    # Return the input class (input class) for a give operation class
    #
    # e.g Operations::User::CreateUser would map to to Inputs::User::CreateUser
    #
    # Returns the class name if no such class can be constantized.
    def self.input_class(operation_class)
      domain_namespace = DomainHelper.to_domain_namespace(operation_class)
      operation_class_name = DomainHelper.to_operation_class_name(operation_class)

      input_class_name = "Inputs::" + domain_namespace + "::" + operation_class_name.sub("Operation", "") + "Input"

      input =
        begin
          input_class_name.constantize
        rescue
          input_class_name
        end

      input
    end
  end
end
