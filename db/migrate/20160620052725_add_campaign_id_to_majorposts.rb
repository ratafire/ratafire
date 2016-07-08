class AddCampaignIdToMajorposts < ActiveRecord::Migration
  def change
  	add_column :majorposts, :campaign_id, :integer
  	add_column :artworks, :campaign_id, :integer
  end
end
