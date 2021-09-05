class CreateContactNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_notifications do |t|
      t.integer :user_id
      t.integer :admin_user_id
      t.integer :message_id
      t.boolean :is_checked

      t.timestamps
    end
  end
end
