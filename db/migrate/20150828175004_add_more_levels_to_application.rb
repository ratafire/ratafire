class AddMoreLevelsToApplication < ActiveRecord::Migration
  def change
  	add_column :subscription_applications, :collectible_20, :text
  	add_column :subscription_applications, :collectible_50, :text
  	add_column :subscription_applications, :collectible_100, :text
  end
end
