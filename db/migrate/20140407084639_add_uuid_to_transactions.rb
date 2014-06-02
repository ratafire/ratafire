class AddUuidToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :uuid, :string
  end
end
