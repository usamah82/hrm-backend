module Types
  # Type to formalize errors returned by a mutation
  class MutationError < Schema::BaseObject
    description "A user-readable error"

    field :message, String, null: false,
      description: "A description of the error"
    field :path, [String], null: true,
      description: "Which input value this error came from"
  end
end
