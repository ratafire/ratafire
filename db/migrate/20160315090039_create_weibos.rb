class CreateWeibos < ActiveRecord::Migration
  def change
    create_table :weibos do |t|
    	t.datetime :deleted_at
    	t.boolean :deleted
    	t.integer :user_id
    	t.string :uuid
    	t.string :uid
    	t.string :nickname
    	t.string :name
    	t.string :location
    	t.string :image
    	t.text :description
    	t.string :url_blog
    	t.string :url_weibo
    	t.string :token
    	t.boolean :expires
    	t.integer :expires_at
      t.timestamps null: false
    end
  end
end
