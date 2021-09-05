class CreateDmNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :dm_notifications do |t|
      t.integer :visitor_id
      t.integer :visited_
      t.integer :message_id
      t.boolean :is_checked

      t.timestamps
    end
  end
end
