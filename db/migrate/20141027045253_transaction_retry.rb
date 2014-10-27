class TransactionRetry < ActiveRecord::Migration
  def up
  	add_column :transactions, :retry, :integer, :default => 0
  end

  def down
  end
end
