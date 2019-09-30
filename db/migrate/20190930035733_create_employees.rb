class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees, id: :uuid do |t|
      t.references :company, null: false
      t.references :user, null: false
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
