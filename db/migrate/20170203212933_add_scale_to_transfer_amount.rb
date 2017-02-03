class AddScaleToTransferAmount < ActiveRecord::Migration
  def change
  	change_column :transfers, :amount, :decimal, :precision => 10, :scale => 2, :default => 0
  end
end
