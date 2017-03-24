class AddAchievementPointsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :achievement_points, :integer, :default => 0
  end
end
