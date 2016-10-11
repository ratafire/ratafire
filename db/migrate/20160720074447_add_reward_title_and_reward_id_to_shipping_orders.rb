class AddRewardTitleAndRewardIdToShippingOrders < ActiveRecord::Migration
  def change
  	add_column :shipping_orders, :reward_title, :string
  end
end
