class AddAccumulatedReceiveToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :accumulated_total, :decimal, :precision => 10, scale: 2
  	add_column :campaigns, :accumulated_receive, :decimal, :precision => 10, scale: 2
  	add_column :campaigns, :accumulated_fee, :decimal, :precision => 10, scale: 2
  end
end
