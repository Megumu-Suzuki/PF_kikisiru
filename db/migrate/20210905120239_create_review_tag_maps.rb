class CreateReviewTagMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :review_tag_maps do |t|
      t.integer :review_id, null: false
      t.integer :tag_id, null: false


      t.timestamps
    end
  end
end
