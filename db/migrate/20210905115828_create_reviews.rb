class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :user_id, null: false
      t.integer :product_id, null: false
      t.string :title, null: false
      t.text :comment, null: false
      t.float :evaluation, null: false, defult: 0

      t.timestamps
    end
  end
end
