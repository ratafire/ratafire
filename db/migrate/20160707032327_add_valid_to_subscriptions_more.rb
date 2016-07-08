class AddValidToSubscriptionsMore < ActiveRecord::Migration
  def change
  	remove_column :subscription_records, :valid
  	add_column :subscription_records, :is_valid, :string, :default => false
  end
end
