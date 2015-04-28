class AddVenmoToTransaction < ActiveRecord::Migration
  def change
  	add_column :transactions, :venmo_transaction_id, :string
  end
end
