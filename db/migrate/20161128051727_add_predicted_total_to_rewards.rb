class AddPredictedTotalToRewards < ActiveRecord::Migration
  def change
  	add_column :rewards, :predicted_total, :decimal, precision: 10, scale: 2, default: 0
  	add_column :rewards, :predicted_receive, :decimal, precision: 10, scale: 2, default: 0
  	add_column :rewards, :predicted_fee, :decimal, precision: 10, scale: 2, default: 0
  	add_column :rewards, :predicted_ratafire, :decimal, precision: 10, scale: 2, default: 0
  	add_column :majorposts, :predicted_total, :decimal, precision: 10, scale: 2, default: 0
  	add_column :majorposts, :predicted_receive, :decimal, precision: 10, scale: 2, default: 0
  	add_column :majorposts, :predicted_fee, :decimal, precision: 10, scale: 2, default: 0
  	add_column :majorposts, :predicted_ratafire, :decimal, precision: 10, scale: 2, default: 0
  	add_column :campaigns, :predicted_total, :decimal, precision: 10, scale: 2, default: 0
  	add_column :campaigns, :predicted_receive, :decimal, precision: 10, scale: 2, default: 0
  	add_column :campaigns, :predicted_fee, :decimal, precision: 10, scale: 2, default: 0
  	add_column :campaigns, :predicted_ratafire, :decimal, precision: 10, scale: 2, default: 0
  end
end
