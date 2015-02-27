class AddCollectableToRewards < ActiveRecord::Migration
  def change
  	add_column :projects, :collectible, :text
  	add_column :subscription_applications, :collectible, :text
  end
end
