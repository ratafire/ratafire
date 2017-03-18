class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.boolean :deleted
      t.datetime :delted_at
      t.string :title
      t.text :content
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
