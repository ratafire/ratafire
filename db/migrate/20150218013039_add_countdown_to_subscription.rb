class AddCountdownToSubscription < ActiveRecord::Migration
  def change
  	#add_column :users, :subscription_status_initial, :string
  	#add_column :subscription_applications, :approved_at, :datetime
  	add_column :subscription_applications, :deadline, :datetime
  end
end
