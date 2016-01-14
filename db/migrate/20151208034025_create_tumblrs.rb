class CreateTumblrs < ActiveRecord::Migration
  def change
    create_table :tumblrs do |t|
    	t.integer :user_id
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :uid
    	t.string :email
    	t.timestamps null: false
    end
  end
end
