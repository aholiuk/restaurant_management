class CreateMenuItems < ActiveRecord::Migration[8.1]
  def change
    create_table :menu_items do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 8, scale: 2, null: false
      t.string :department, null: false, default: "kitchen"
      t.boolean :available, null: false, default: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
  end
end