class ChangeDefaultAmoutsForSomeColumns < ActiveRecord::Migration
  def up
  	remove_column :transfers, :fee
  	remove_column :transfers, :receive
  	remove_column :transfers, :amout
  	add_column :transfers, :fee, :decimal, :default => 0, :precision => 10, :scale => 0
  	add_column :transfers, :receive, :decimal, :default => 0, :precision => 10, :scale => 0
  	add_column :transfers, :amount, :decimal, :default => 0, :precision => 10, :scale => 0
  end

  def down
  end
end
