class AddGoalsToSubscriptionApplication < ActiveRecord::Migration
  def change
  	add_column :subscription_applications, :goals_subscribers, :integer
  	add_column :subscription_applications, :goals_monthly, :integer
  	add_column :subscription_applications, :goals_project, :integer
  end
end
