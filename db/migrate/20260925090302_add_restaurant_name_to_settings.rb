class AddRestaurantNameToSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :settings, :restaurant_name, :string, null: false, default: "Mein Restaurant"
  end
end