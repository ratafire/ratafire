class AddBatchedToTransfers < ActiveRecord::Migration
  def change
  	add_column :transfers, :queued, :boolean
  end
end
