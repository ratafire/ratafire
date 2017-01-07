class AddOrderSubsetIdToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :order_subset_id, :integer
  end
end
