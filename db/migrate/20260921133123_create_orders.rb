class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :order_type, null: false
      t.string :customer_name, null: false
      t.string :address
      t.integer :table_number
      t.string :status, null: false, default: "placed"

      t.timestamps
    end
  end
end