class CreateTwitches < ActiveRecord::Migration
  def change
    create_table :twitches do |t|
    	t.integer :user_id
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :uid
    	t.string :name
    	t.string :email
    	t.string :nickname
    	t.string :description
    	t.string :image
    	t.string :token
    	t.boolean :expires
    	t.string :display_name
    	t.string :type
    	t.string :bio
    	t.string :created_at
    	t.string :updated_at
    	t.string :link_self
    	t.boolean :partnered
    	t.timestamps null: false
    end
  end
end
