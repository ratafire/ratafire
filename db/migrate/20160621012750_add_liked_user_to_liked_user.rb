class AddLikedUserToLikedUser < ActiveRecord::Migration
  def change
  	add_column :liked_users, :liked_id, :integer
  	remove_column :liked_users, :user_id
  end
end
