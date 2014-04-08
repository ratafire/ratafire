class ChangeSubscriptionRecords < ActiveRecord::Migration
  def up
  	change_column :subscription_records, :accumulated_receive, :decimal, :precision => 10, :scale => 2, :default => 0.00
  	change_column :subscription_records, :accumulated_amazon, :decimal, :precision => 10, :scale => 2, :default => 0.00
  	change_column :subscription_records, :accumulated_ratafire, :decimal, :precision => 10, :scale => 2, :default => 0.00
  	change_column :subscription_records, :accumulated_total, :decimal, :precision => 10, :scale => 2, :default => 0.00
  end

  def down
  end
end
