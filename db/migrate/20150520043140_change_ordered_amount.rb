class ChangeOrderedAmount < ActiveRecord::Migration
  def up
  	remove_column :transfers, :ordered_amount
  	add_column :transfers, :ordered_amount, :decimal, :default => 0, :precision => 10, :scale => 2
  end

  def down
  end
end
