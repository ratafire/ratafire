class AddCampaignIdToVideo < ActiveRecord::Migration
  def change
  	add_column :videos, :campaign_id, :integer
  end
end
