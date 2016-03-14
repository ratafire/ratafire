class AddActiveToRewards < ActiveRecord::Migration
  def change
  	add_column :rewards, :active, :boolean
  end
end
