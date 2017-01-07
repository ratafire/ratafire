class AddUpdatesToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :updates, :integer, :default => 0
  end
end
