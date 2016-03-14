class AddMaestroToCampaignsAndUsers < ActiveRecord::Migration
  def change
  	add_column :campaigns, :maestro, :boolean, :default => false
  end
end
