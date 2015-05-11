class AddPostToFacebookToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :post_to_facebook, :boolean
  end
end
