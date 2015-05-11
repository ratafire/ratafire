class CreateFriendConnections < ActiveRecord::Migration
  def change
    create_table :friend_connections do |t|

      t.timestamps
    end
  end
end
