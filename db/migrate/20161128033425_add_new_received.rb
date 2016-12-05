class AddNewReceived < ActiveRecord::Migration
  def change
  	add_column :rewards, :accumulated_total, :decimal, precision: 10, scale: 2, default: 0
  	add_column :rewards, :accumulated_receive, :decimal, precision: 10, scale: 2, default: 0
  	add_column :rewards, :accumulated_fee, :decimal, precision: 10, scale: 2, default: 0
  	add_column :rewards, :accumulated_ratafire, :decimal, precision: 10, scale: 2, default: 0
  	add_column :majorposts, :accumulated_total, :decimal, precision: 10, scale: 2, default: 0
  	add_column :majorposts, :accumulated_receive, :decimal, precision: 10, scale: 2, default: 0
  	add_column :majorposts, :accumulated_fee, :decimal, precision: 10, scale: 2, default: 0
  	add_column :majorposts, :accumulated_ratafire, :decimal, precision: 10, scale: 2, default: 0
  end
end
