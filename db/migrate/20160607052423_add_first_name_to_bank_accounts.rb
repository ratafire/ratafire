class AddFirstNameToBankAccounts < ActiveRecord::Migration
  def change
  	add_column :bank_accounts, :first_name, :string
  	add_column :bank_accounts, :last_name, :string
  end
end
