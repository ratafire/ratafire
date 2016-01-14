class CreateYoutubes < ActiveRecord::Migration
  def change
    create_table :youtubes do |t|
    	t.integer :user_id
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :uid
    	t.string :name
    	t.string :email
    	t.string :first_name
    	t.string :last_name
    	t.string :image
    	t.string :token
    	t.string :refresh_token
    	t.string :expires_at
    	t.boolean :expires
    	t.string :sub
    	t.boolean :email_verified
    	t.string :given_name
    	t.string :profile
    	t.string :picture
    	t.string :gender
    	t.string :birthday
    	t.string :locale
    	t.string :hd
    	t.string :iss
    	t.string :at_hash
    	t.string :id_info_sub
    	t.string :azp
    	t.string :aud
    	t.string :iat
    	t.string :exp
    	t.string :openid_id
    	t.timestamps null: false
    end
  end
end
