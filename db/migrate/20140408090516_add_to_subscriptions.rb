class AddToSubscriptions < ActiveRecord::Migration
  def up
  	change_column :subscriptions, :accumulated_receive, :decimal,:precision => 10, :scale => 2, :default => 0.0
  	change_column :subscriptions, :accumulated_amazon, :decimal,:precision => 10, :scale => 2, :default => 0.0
  	change_column :subscriptions, :accumulated_ratafire, :decimal,:precision => 10, :scale => 2, :default => 0.0
  	change_column :subscriptions, :accumulated_total, :decimal,:precision => 10, :scale => 2, :default => 0.0
  end

  def down
  end
end
