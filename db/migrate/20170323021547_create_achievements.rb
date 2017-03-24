class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
    	t.integer :user_id
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :name
    	t.string :name_zh
    	t.string :uuid
    	t.integer :achievement_id
    	t.string :image
    	t.integer :achievement_point
    	t.string :category
    	t.string :sub_category
    	t.string :description
    	t.string :description_zh
    	t.string :achievement_reward_zh
    	t.string :achievement_reward
    	t.string :achievement_reward_id
        t.integer :level
        t.integer :merit_id
      t.timestamps null: false
    end
  end
end
