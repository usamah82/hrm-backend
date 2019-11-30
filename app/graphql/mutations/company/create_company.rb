module Mutations
  module Company
    # CreateCompany mutation
    class CreateCompany < Schema::BaseMutation
      null false

      description "Create company"

      argument :administrator_email, String, required: true
      argument :administrator_name, String, required: true

      argument :company_name, String, required: true
      argument :country_code, String, required: true

      field :company, Types::Company, null: true
      field :errors, [Types::MutationError], null: false

      # Mutation resolver
      def resolve(**args)
        result = Operations::Company::CreateCompanyOperation.call(args)
        render_fields(company: result.data, errors: result.errors)
      end
    end
  end
end
