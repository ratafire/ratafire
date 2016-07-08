class CreateLikeUsers < ActiveRecord::Migration
  def change
    create_table :like_users do |t|
	t.integer :user_id
	t.integer :liker_id
      t.timestamps null: false
    end
  end
end
