class CreateDirectMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_messages do |t|
      t.integer :user_id
      t.integer :room_id
      t.text :message, null: false
      t.boolean :is_checked, default: false, null: false

      t.timestamps
    end
  end
end
