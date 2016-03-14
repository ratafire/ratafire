class AddRecipientToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :recipient, :boolean
  end
end
