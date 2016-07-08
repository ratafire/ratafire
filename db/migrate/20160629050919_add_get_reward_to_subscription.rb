class AddGetRewardToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :get_reward, :boolean
  end
end
