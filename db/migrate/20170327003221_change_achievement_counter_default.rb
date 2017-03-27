class ChangeAchievementCounterDefault < ActiveRecord::Migration
  def change
  	change_column :achievement_counters, :count, :integer, :default => 0
  end
end
