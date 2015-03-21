class AddATimeToSubscriptionApplication < ActiveRecord::Migration
  def change
  	add_column :subscription_applications, :approved_at, :datetime
  	add_column :subscription_applications, :completed_at, :datetime
  end
end
