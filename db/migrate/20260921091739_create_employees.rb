class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false, default: "server"
      t.boolean :active, null: false, default: true

      t.timestamps
    end
    add_index :employees, :email, unique: true
  end
end