class AddSubscriptionInactiveToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :subscription_inactive, :boolean
  	add_column :users, :subscription_inactive_at, :datetime
  end
end
