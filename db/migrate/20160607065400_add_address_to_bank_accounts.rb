class AddAddressToBankAccounts < ActiveRecord::Migration
  def change
  	add_column :bank_accounts, :city, :string
  	add_column :bank_accounts, :line1, :string
  	add_column :bank_accounts, :line2, :string
  	add_column :bank_accounts, :postal_code, :string
  end
end
