class AddApplicationFeeToTransfer < ActiveRecord::Migration
  def change
  	add_column :transfers, :balance_transaction, :string
  	add_column :transfers, :destination_payment, :string
  	add_column :transfers, :description, :string
  	add_column :transfers, :destination, :string
  	add_column :transfers, :failure_code, :string
  	add_column :transfers, :failure_message, :string
  	add_column :transfers, :source_transaction, :string
  	add_column :transfers, :source_type, :string
  	add_column :transfers, :statement_descriptor, :string
  end
end
