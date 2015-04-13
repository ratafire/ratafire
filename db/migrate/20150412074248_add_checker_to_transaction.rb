class AddCheckerToTransaction < ActiveRecord::Migration
  def change
  	add_column :transactions, :fee, :decimal, :precision => 10, :scale => 2
  end
end
