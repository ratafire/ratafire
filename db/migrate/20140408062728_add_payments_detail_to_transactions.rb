class AddPaymentsDetailToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :ratafire_fee, :decimal, :precision => 10, :scale => 2
  end
end
