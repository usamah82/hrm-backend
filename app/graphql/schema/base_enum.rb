module Schema
  # Base class for all deriving GraphQL enum classes
  #
  class BaseEnum < GraphQL::Schema::Enum
    include BaseSharedMethods
  end
end
