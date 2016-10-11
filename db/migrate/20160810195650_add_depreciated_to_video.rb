class AddDepreciatedToVideo < ActiveRecord::Migration
  def change
  	add_column :videos, :deleted_at, :datetime
  	add_column :videos, :deleted, :boolean
  end
end
