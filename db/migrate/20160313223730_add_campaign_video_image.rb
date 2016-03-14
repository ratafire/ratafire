class AddCampaignVideoImage < ActiveRecord::Migration
  def change
  	add_column :video_images, :campaign_id, :integer
  end
end
