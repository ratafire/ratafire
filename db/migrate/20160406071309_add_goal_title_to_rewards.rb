class AddGoalTitleToRewards < ActiveRecord::Migration
  def change
  	add_column :rewards, :goal_title, :string
  	remove_column :rewards, :goal
  	add_column :rewards, :goal, :decimal, :precision => 10, :scale => 2, default: 0
  end
end
