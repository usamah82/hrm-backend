module FormObjects
  # Base class for form object implementations.
  class BaseFormObject
    include ActiveModel::Validations

    # Initializes the form object
    def initialize(**args)
      @args = args
    end
  end
end
