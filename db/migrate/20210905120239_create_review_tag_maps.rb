class CreateReviewTagMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :review_tag_maps do |t|
      t.integer :review_id
      t.integer :tag_id


      t.timestamps
    end
  end
end
