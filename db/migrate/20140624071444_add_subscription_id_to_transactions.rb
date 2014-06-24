class AddSubscriptionIdToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :subscription_id, :integer
  end
end
