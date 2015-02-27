class AddCountdownToSubscription < ActiveRecord::Migration
  def change
  	add_column :users, :subscription_status_initial, :string
  	add_column :subscription_applications, :approved_at, :date_time
  	add_column :subscription_application, :deadline, :date_time
  end
end
