class AddIvToEncrypted < ActiveRecord::Migration
  def change
  	add_column :bank_accounts, :encrypted_account_number_iv, :string
  	add_column :bank_accounts, :encrypted_routing_number_iv, :string
  end
end
