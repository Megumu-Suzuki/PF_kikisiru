class CreateProductTagMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :product_tag_maps do |t|
      t.integer :product_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
