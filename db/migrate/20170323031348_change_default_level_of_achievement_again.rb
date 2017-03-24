class ChangeDefaultLevelOfAchievementAgain < ActiveRecord::Migration
  def change
  	change_column :achievements, :image, :string, :default => '/assets/logo/logoicon_water_large_flat.jpg'
  	change_column :achievements, :level, :integer, default: 1
  end
end
