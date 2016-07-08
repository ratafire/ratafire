class AddSubscriptionIdToShippingAddress < ActiveRecord::Migration
  def change
  	add_column :shipping_addresses, :subscription_id, :integer
  	add_column :shipping_addresses, :name, :string
  end
end
