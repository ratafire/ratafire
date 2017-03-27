class CreateAchievementCounters < ActiveRecord::Migration
  def change
    create_table :achievement_counters do |t|
    	t.integer :achievement_id
    	t.integer :user_id
    	t.string :uuid
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.integer :achievement_relationship_id
    	t.integer :count
    	t.integer :count_goal
    	t.boolean :goal_reached, default: false
      t.timestamps null: false
    end
    add_column :achievements, :count_goal, :integer
  end
end
