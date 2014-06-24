class AddMonthToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :this_billing_date, :datetime
  	add_column :subscriptions, :next_billing_date, :datetime
  end
end
