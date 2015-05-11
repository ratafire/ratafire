class AddFacebookPostsAccessToken < ActiveRecord::Migration
  def up
  	add_column :facebooks, :post_access_token, :string
  	add_column :projects, :post_to_facebook, :boolean, :default => false
  	add_column :projects, :post_to_facebook_page, :boolean, :default => false
  	add_column :majorposts, :post_to_facebook, :boolean, :default => false
  	add_column :majorposts, :post_to_facebook_page, :boolean, :default => false
  	add_column :discussions, :post_to_facebook, :boolean, :default => false
  	add_column :discussions, :post_to_facebook_page, :boolean, :default => false
  	add_column :facebook_pages, :post_to_facebook_page, :boolean
  end

  def down
  end
end
