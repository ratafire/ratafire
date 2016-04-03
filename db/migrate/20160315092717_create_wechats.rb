class CreateWechats < ActiveRecord::Migration
  def change
    create_table :wechats do |t|
    	t.integer :user_id
    	t.datetime :deleted_at
    	t.boolean :deleted
    	t.string :uid
    	t.string :uuid 
    	t.string :nickname
    	t.integer :sex
    	t.string :province
    	t.string :city
    	t.string :country
    	t.string :headimgurl
    	t.string :token
    	t.string :refresh_token
    	t.integer :expires_at
    	t.boolean :expires
    	t.string :openid
      t.timestamps null: false
    end
  end
end
