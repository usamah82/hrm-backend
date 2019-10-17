module FormObjects
  # Base class for form object implementations.
  class BaseFormObject
    include ActiveModel::Validations
  end
end
