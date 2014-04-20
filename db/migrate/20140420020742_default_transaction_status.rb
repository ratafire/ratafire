class DefaultTransactionStatus < ActiveRecord::Migration
  def up
  	change_column :transactions, :status, :string, :default => "Error"
  end

  def down
  end
end
