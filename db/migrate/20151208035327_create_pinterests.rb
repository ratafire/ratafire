class CreatePinterests < ActiveRecord::Migration
  def change
    create_table :pinterests do |t|
    	t.integer :user_id
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :uid 
    	t.string :pinterest_id
    	t.string :url
    	t.string :first_name
    	t.string :last_name
    	t.string :email
    	t.timestamps null: false
    end
  end
end
