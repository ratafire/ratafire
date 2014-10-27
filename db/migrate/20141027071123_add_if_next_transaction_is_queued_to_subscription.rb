class AddIfNextTransactionIsQueuedToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :next_transaction_queued, :boolean, :default => false
  end
end
