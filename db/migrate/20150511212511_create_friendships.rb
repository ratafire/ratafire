class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.boolean :deleted
      t.datetime :deleted_at
      t.string :user_facebook_uid
      t.string :friend_facebook_uid
      t.timestamps
    end
  end
end
