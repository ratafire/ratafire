class AddFutureTransactions < ActiveRecord::Migration
  def up
  	add_column :transactions, :next_transaction, :datetime
  	add_column :transactions, :next_transaction_status, :boolean, :default => false 
  end

  def down
  end
end
