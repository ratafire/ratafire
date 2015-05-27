class ChangeSubscriptionSwitch < ActiveRecord::Migration
  def up
  	remove_column :users, :subscription_switch
  	add_column :users, :subscription_switch, :boolean, :default => true
  end

  def down
  end
end
