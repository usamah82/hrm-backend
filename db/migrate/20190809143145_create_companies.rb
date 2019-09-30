class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies, id: :uuid do |t|
      t.string :name, null: false
      t.string :country_code, null: false
      t.timestamps null: false
    end
  end
end
