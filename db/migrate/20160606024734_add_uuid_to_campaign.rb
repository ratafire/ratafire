class AddUuidToCampaign < ActiveRecord::Migration
  def change
  	add_column :artworks, :campaign_uuid, :string
  end
end
