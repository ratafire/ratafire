class AddSupporterToSubscription < ActiveRecord::Migration
  def change
  		add_column :subscriptions, :supporter, :boolean, :default => false
  		add_column :subscription_records, :supporter, :boolean, :default => false
  		add_column :transactions, :supporter, :boolean, :default => false
  end
end
