class AddRetryToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :retry, :integer, :default => 0
  end
end
