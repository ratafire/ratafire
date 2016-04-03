class CreateTaobaos < ActiveRecord::Migration
  def change
    create_table :taobaos do |t|
    	t.datetime :deleted_at
    	t.boolean :deleted
    	t.integer :user_id
    	t.string :uuid
    	t.string :uid
    	t.string :nickname
    	t.string :email
    	t.string :alipay_bind
    	t.string :token
    	t.string :refresh_token
    	t.text :test
    	t.integer :expires_at
    	t.boolean :expires
      t.timestamps null: false
    end
  end
end
