class AddEmailConfirmationToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :unconfirmed_email, :string
    add_column :employees, :confirmation_token, :string
    add_index :employees, :confirmation_token, unique: true
  end
end