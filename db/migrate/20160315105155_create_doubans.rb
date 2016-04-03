class CreateDoubans < ActiveRecord::Migration
  def change
    create_table :doubans do |t|
    	t.integer :user_id
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :uuid
    	t.string :uid
    	t.string :name
    	t.string :nickname
    	t.string :location
    	t.string :image
    	t.string :url
    	t.text :description
    	t.string :token
    	t.string :refresh_token
    	t.integer :expires_at
    	t.boolean :expires
    	t.string :loc_id
    	t.string :created
    	t.string :loc_name
    	t.string :avatar
    	t.string :signature
      t.timestamps null: false
    end
  end
end
