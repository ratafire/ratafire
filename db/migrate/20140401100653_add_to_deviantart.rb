class AddToDeviantart < ActiveRecord::Migration
  def up
  	add_column :deviantarts, :uid, :string
  	add_column :deviantarts, :nickname, :string
  	add_column :deviantarts, :image, :string
  	add_column :deviantarts, :oauth_token, :string
  	add_column :deviantarts, :oauth_token_expires_at, :string
  	add_column :deviantarts, :link, :string  	
  end

  def down
  end
end
