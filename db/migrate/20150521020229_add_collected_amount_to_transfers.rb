class AddCollectedAmountToTransfers < ActiveRecord::Migration
  def change
  	add_column :transfers, :collected_amount, :decimal, :default => 0, :precision => 10, :scale => 2
  	add_column :transfers, :collected_fee, :decimal, :default => 0, :precision => 10, :scale => 2
  	add_column :transfers, :collected_receive, :decimal, :default => 0, :precision => 10, :scale => 2
  	add_column :orders, :count, :integer, :default => 0
  end
end
