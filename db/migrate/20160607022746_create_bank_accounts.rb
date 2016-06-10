class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
    	t.string :uuid
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :stripe_id
    	t.string :object
    	t.string :account_holder_name
    	t.string :account_holder_type
    	t.string :bank_name
    	t.string :country
    	t.string :currency
    	t.boolean :default_for_currency
    	t.string :fingerprint
    	t.string :last4
    	t.string :routing_number
    	t.string :encrypted_routing_number
    	t.string :status
    	t.string :account_number
    	t.string :encrypted_account_number
    	t.integer :user_id
    	t.integer :campaign_id
      t.timestamps null: false
    end
  end
end
