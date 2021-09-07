class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :user_id, null: false
      t.integer :genre_id
      t.string :title, null: false, limit: 30
      t.text :description
      t.string :model, null: false, unique: true
      t.integer :price
      t.integer :manufacture
      t.integer :width
      t.integer :depth
      t.integer :height
      t.float :weight
      t.integer :phase
      t.float :power_consumption
      t.float :city_gas
      t.float :propane_gas
      t.boolean :allow_edit, null: false, default: true

      t.timestamps
    end
  end
end
