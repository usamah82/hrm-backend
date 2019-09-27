module GraphqlSpecHelper
  def execute_graphql_query!
    result = AppSchema.execute(
      @query,
      context: @context,
      variables: @variables
    )

    result
  end

  def prepare_query_variables(variables)
    @variables = variables
  end

  def prepare_context(context)
    @context = context
  end

  def prepare_query(query)
    @query = query
  end
end
