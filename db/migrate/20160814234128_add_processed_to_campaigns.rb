class AddProcessedToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :processed, :boolean, :default => false, :null => false
  end
end
