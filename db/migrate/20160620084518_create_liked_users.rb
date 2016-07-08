class CreateLikedUsers < ActiveRecord::Migration
  def change
    create_table :liked_users do |t|
		t.integer :user_id
		t.integer :liker_id
      t.timestamps null: false
    end
    drop_table :like_users
  end
end
