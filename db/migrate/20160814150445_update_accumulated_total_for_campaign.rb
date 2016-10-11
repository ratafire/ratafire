class UpdateAccumulatedTotalForCampaign < ActiveRecord::Migration
  def change
  	remove_column :campaigns, :accumulated_total
  	remove_column :campaigns, :accumulated_receive
  	remove_column :campaigns, :accumulated_fee
  	add_column :campaigns, :accumulated_total, :decimal, :precision => 10, :scale => 2, :default => 0
  	add_column :campaigns, :accumulated_receive, :decimal, :precision => 10, :scale => 2, :default => 0
  	add_column :campaigns, :accumulated_fee, :decimal, :precision => 10, :scale => 2, :default => 0
  	add_column :campaigns, :accumulated_ratafire, :decimal, :precision => 10, :scale => 2, :default => 0  	  	
  end
end
