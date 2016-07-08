class ChangeGetReward < ActiveRecord::Migration
  def change
  	change_column :subscriptions, :get_reward, :string
  	add_column :subscriptions, :get_reward_false, :string
  end
end
