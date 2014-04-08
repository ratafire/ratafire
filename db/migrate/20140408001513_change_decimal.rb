class ChangeDecimal < ActiveRecord::Migration
  def up
  	change_column :subscription_records, :accumulated_receive, :decimal, :precision => 10, :scale => 2
  	change_column :subscription_records, :accumulated_amazon, :decimal, :precision => 10, :scale => 2
  	change_column :subscription_records, :accumulated_ratafire, :decimal, :precision => 10, :scale => 2
  	change_column :subscription_records, :accumulated_total, :decimal, :precision => 10, :scale => 2

  	change_column :subscriptions, :amount, :decimal, :precision => 10, :scale => 2
  	change_column :subscriptions, :accumulated_receive, :decimal, :precision => 10, :scale => 2
  	change_column :subscriptions, :accumulated_amazon, :decimal, :precision => 10, :scale => 2
  	change_column :subscriptions, :accumulated_ratafire, :decimal, :precision => 10, :scale => 2
  	change_column :subscriptions, :accumulated_total, :decimal, :precision => 10, :scale => 2

  	change_column :transactions, :receive, :decimal, :precision => 10, :scale => 2
  	change_column :transactions, :ratafire, :decimal, :precision => 10, :scale => 2
  	change_column :transactions, :total, :decimal, :precision => 10, :scale => 2

  	change_column :amazon_recipients, :maxFixedFee, :decimal, :precision => 10, :scale => 2
  	change_column :amazon_recipients, :maxVariableFee, :decimal, :precision => 10, :scale => 2
  end

  def down
  end
end
