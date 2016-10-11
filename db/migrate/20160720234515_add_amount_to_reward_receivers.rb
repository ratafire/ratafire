class AddAmountToRewardReceivers < ActiveRecord::Migration
  def change
  	add_column :reward_receivers, :amount, :decimal, :precision => 10, scale: 2, default: 0
  end
end
