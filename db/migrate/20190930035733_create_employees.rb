class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees, id: :uuid do |t|
      t.references :company, type: :uuid, null: false
      t.references :user, type: :uuid, null: false
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
