class AddProjectIdToSubscriptionApplication < ActiveRecord::Migration
  def change
  	add_column :subscription_applications, :project_id, :integer
  end
end
