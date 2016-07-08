class AddCampaignFundingTypeToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :campaign_funding_type, :string
  end
end
