class ChangeTransactions < ActiveRecord::Migration
  def up
  	change_column :transactions, :ratafire, :integer
  	change_column :transactions, :amazon, :decimal, :precision => 10, :scale => 2
  end

  def down
  end
end
