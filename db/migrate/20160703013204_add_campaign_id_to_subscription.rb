class AddCampaignIdToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :campaign_id, :integer
  end
end
