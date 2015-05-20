class AddDeletedInfoToTransfers < ActiveRecord::Migration
  def change
  	add_column :transfers, :deleted, :boolean
  	add_column :transfers, :deleted_at, :datetime
  end
end
