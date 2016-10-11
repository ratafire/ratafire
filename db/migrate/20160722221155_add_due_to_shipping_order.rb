class AddDueToShippingOrder < ActiveRecord::Migration
  def change
  	add_column :shipping_orders, :due, :datetime
  	add_column :campaigns, :expiration_queued, :boolean
  	add_column :campaigns, :expired, :boolean
  	add_column :campaigns, :expired_at, :datetime
  	add_column :rewards, :expiration_queued, :boolean
  	add_column :rewards, :expired, :boolean
  	add_column :rewards, :expired_at, :datetime
  	add_column :shipping_orders, :expiration_queued, :boolean
  	add_column :shipping_orders, :expired, :boolean
  	add_column :shipping_orders, :expired_at, :datetime
  end
end
