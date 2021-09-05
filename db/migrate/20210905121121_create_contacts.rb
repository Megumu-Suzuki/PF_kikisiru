class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.string :name
      t.string :subject
      t.text :body
      t.boolean :is_completed

      t.timestamps
    end
  end
end
