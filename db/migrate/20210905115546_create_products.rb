class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :user_id
      t.integer :genre_id
      t.string :title
      t.text :description
      t.string :type
      t.integer :price
      t.string :manufacture
      t.integer :width
      t.integer :depth
      t.integer :height
      t.integer :weight
      t.string :fuel
      t.integer :power_consumplion
      t.integer :gas_consumplion
      t.boolean :allow_edit

      t.timestamps
    end
  end
end
