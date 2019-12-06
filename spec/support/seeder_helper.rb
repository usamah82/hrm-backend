module SeederHelper
  def create_company
    Operations::Company::CreateCompanyOperation.(
      administrator_name: Faker::Name.name,
      administrator_email: Faker::Internet.email,
      company_name: Faker::Company.name,
      company_country_code: Faker::Address.country_code
    ).data
  end
end
