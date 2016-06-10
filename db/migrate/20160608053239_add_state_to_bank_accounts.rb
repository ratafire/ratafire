class AddStateToBankAccounts < ActiveRecord::Migration
  def change
  	add_column :bank_accounts, :state, :string
  end
end
