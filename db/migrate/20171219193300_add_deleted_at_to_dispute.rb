class AddDeletedAtToDispute < ActiveRecord::Migration
  def change
  	add_column :disputes, :deleted_at, :datetime
  	add_column :disputes, :deleted, :boolean
  end
end
