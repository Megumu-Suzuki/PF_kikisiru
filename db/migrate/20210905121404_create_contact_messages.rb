class CreateContactMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_messages do |t|
      t.integer :user_id
      t.integer :admin_id
      t.integer :contact_id, null: false
      t.string :name, null: false 
      t.string :email, null: false
      t.string :subject, null: false 
      t.text :body, null: false

      t.timestamps
    end
  end
end
