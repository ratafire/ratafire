class ChangeTheLevelDefaultOfAchievement < ActiveRecord::Migration
  def change
  	remove_column :achievements, :achievement_point
  	add_column :achievements, :achievement_points, :integer, default: 0
  	change_column :achievements, :level, :integer, default: 0
  end
end
