class AddFirstBloodToSubscriptionRecords < ActiveRecord::Migration
  def change
  	add_column :subscription_records, :first_blood, :boolean
  end
end
