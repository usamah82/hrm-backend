# GraphQL Schema
class AppSchema < GraphQL::Schema
  query(Types::Root::Query)
  mutation(Types::Root::Mutation)
end
