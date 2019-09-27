module Schema
  # Base class for GraphQL object
  #
  class BaseObject < GraphQL::Schema::Object
    include BaseSharedMethods

    field_class BaseField
    connection_type_class Types::BaseConnection
  end
end
