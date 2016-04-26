class AddGoalsToRewards < ActiveRecord::Migration
  def change
  	remove_column :rewards, :goal_id
  	add_column :rewards, :due, :datetime
  	add_column :rewards, :goal, :decimal, :precision => 10, scale: 2, :deafult => 0
  	add_column :rewards, :received, :decimal, :precision => 10, scale: 2, :default => 0
  	Reward.create_translation_table! :title => :string, :description => :text
  end
end
