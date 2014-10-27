class AddTransactionCounter < ActiveRecord::Migration
  def up
  	add_column :transactions, :counter, :integer, :default => 0
  	add_column :subscriptions, :counter, :integer, :default => 0
  	add_column :subscription_records, :counter, :integer, :default => 0  	
  end

  def down
  end
end
