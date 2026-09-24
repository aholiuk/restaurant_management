class CreateSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :settings do |t|
      t.string :theme, null: false, default: "rustico"

      t.timestamps
    end
  end
end