# GraphQL Schema
class AppSchema < GraphQL::Schema
  query(Types::Root::Query)
  mutation(Types::Root::Mutation)

  rescue_from(Pundit::NotAuthorizedError) do |err, obj, args, ctx, field|
    GraphQL::ExecutionError.new(err.message, extensions: { code: "UNAUTHORIZED_ACCESS" })
  end

  rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
    nil
  end

  rescue_from(StandardError) do |err, obj, args, ctx, field|
    # TODO - Need to log this for further action.
    GraphQL::ExecutionError.new(err.message, extensions: { code: "INTERNAL_SERVER_ERROR" })
  end
end
