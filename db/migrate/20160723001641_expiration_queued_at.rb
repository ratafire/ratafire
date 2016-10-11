class ExpirationQueuedAt < ActiveRecord::Migration
  def change
  	add_column :rewards, :expiration_queued_at, :datetime
  	add_column :shipping_orders, :expiration_queued_at, :datetime
  	add_column :campaigns, :expiration_queued_at, :datetime
  	add_column :rewards, :estimated_delivery_expired, :boolean
  	add_column :rewards, :estimated_delivery_expired_at, :boolean
  	add_column :rewards, :estimated_delivery_expiration_queued_at, :datetime
  	add_column :rewards, :estimated_delivery_expiration_queued, :boolean
  end
end
