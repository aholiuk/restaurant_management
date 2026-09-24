class CreateStatusLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :status_logs do |t|
      t.references :order, null: false, foreign_key: true
      t.references :employee, null: true, foreign_key: true
      t.string :status, null: false
      t.datetime :changed_at, null: false

      t.timestamps
    end
  end
end