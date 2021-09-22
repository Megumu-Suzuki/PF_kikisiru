class CreateReviewImages < ActiveRecord::Migration[5.2]
  def change
    create_table :review_images do |t|
      t.integer :review_id, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
