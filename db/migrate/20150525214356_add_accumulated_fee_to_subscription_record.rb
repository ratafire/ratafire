class AddAccumulatedFeeToSubscriptionRecord < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :accumulated_fee, :decimal, :default => 0, :precision => 10, :scale => 2
  	add_column :subscription_records, :accumulated_fee, :decimal, :default => 0, :precision => 10, :scale => 2
  end
end
