class AddNewDurationsToSubscriptionRecord < ActiveRecord::Migration
  def change
  	add_column :subscription_records, :past_support, :boolean, :default => false
  	add_column :subscription_records, :duration_support, :boolean, :default => false
  end
end
