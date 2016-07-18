class AddCampaignIdToTransactionSubset < ActiveRecord::Migration
  def change
  	add_column :transaction_subsets, :campaign_id, :integer
  end
end
