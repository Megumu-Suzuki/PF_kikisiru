class CreateContactMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_messages do |t|
      t.integer :user_id
      t.integer :admin_user_id
      t.integer :contact_id
      t.text :message

      t.timestamps
    end
  end
end
