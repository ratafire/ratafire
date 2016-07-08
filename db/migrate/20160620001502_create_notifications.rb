class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
        t.string :uuid
    	t.datetime :deleted_at
    	t.boolean :deleted
    	t.integer :user_id
    	t.integer :trackable_id
    	t.string :trackable_type
    	t.text :content
    	t.string :title
    	t.boolean :is_read, :default => false
    	t.integer :owner_id
    	t.string :owner_type
        t.string :notification_type
      t.timestamps null: false
    end

  end
end
