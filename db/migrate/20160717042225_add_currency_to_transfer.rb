class AddCurrencyToTransfer < ActiveRecord::Migration
  def change
  	add_column :transfers, :currency, :string
  end
end
