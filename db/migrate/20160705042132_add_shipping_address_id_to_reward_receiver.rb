class AddShippingAddressIdToRewardReceiver < ActiveRecord::Migration
  def change
  	add_column :reward_receivers, :shipping_address_id, :string
  end
end
