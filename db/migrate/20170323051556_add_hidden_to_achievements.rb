class AddHiddenToAchievements < ActiveRecord::Migration
  def change
  	add_column :achievements, :hidden, :boolean, :default => false
  end
end
