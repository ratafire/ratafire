class AddProccessedToTransfers < ActiveRecord::Migration
  def change
  	add_column :transfers, :completed, :boolean
  	add_column :transfers, :completed_at, :datetime
  end
end
