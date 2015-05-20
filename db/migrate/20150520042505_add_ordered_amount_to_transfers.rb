class AddOrderedAmountToTransfers < ActiveRecord::Migration
  def change
  	add_column :transfers, :ordered_amount, :decimal, :precision => 10, :scale => 2
  end
end
