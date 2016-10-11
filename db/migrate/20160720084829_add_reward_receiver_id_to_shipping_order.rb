class AddRewardReceiverIdToShippingOrder < ActiveRecord::Migration
  def change
  	add_column :shipping_orders, :reward_receiver_id, :integer
  end
end
