module Operations
  module Company
    # Creates a company
    class CreateCompanyOperation < Operations::BaseOperation
      private
        def process
          ActiveRecord::Base.transaction do
            company = create_company
            user = create_user
            create_employee(company, user)

            company
          end
        end

        def create_company
          ::Company.create!(
            name: @input.company_name,
            country_code: @input.company_country_code
          )
        end

        def create_user
          Operations::User::CreateUserOperation.(
            name: @input.administrator_name,
            email: @input.administrator_email
          ).data
        end

        def create_employee(company, user)
          ::Employee.create!(
            name: user.name,
            email: user.email,
            company: company,
            user: user
          )
        end
    end
  end
end
