class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.boolean :is_completed, default: true, null: false

      t.timestamps
    end
  end
end
