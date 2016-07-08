class AddCreditToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscription_records, :credit, :decimal, :precision => 10, :scale => 2, :default => 0
  	add_column :reward_receivers, :paid, :boolean, :default => false
  end
end
