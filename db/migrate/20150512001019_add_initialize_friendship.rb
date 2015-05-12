class AddInitializeFriendship < ActiveRecord::Migration
  def up
  	add_column :friendships, :friendship_init, :integer
  end

  def down
  end
end
