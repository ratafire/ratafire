class UserLevelSetToDefault1 < ActiveRecord::Migration
  def change
  	change_column :users, :level, :integer, :default => 1
  	add_column :level_xps, :total_xp_required, :integer
  end
end
