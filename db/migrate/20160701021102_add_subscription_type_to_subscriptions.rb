class AddSubscriptionTypeToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :subscription_type, :string
  	add_column :subscriptions, :organization, :boolean, :default => false
  end
end
