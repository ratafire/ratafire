class AddErrorToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :error, :string
  end
end
