class AddUidToPaypalAccounts < ActiveRecord::Migration
  def change
  	add_column :paypal_accounts, :uid, :string
  end
end
