class AddNotBeingActiveToSubscription < ActiveRecord::Migration
  def change
  	add_column :users, :subscription_inactive, :boolean
  end
end
