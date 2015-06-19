class AddTransferAmountToTransfers < ActiveRecord::Migration
  def change
  	add_column :transfers, :transfer_amount, :decimal, :precision => 10, :scale => 2, :default => 0
  	add_column :transfers, :transfer_fee, :decimal, :precision => 10, :scale => 2, :default => 0
  end
end
