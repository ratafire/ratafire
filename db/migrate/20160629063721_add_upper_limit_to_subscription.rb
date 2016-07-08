class AddUpperLimitToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :upper_limit, :integer
  end
end
