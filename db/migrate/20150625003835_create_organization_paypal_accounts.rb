class CreateOrganizationPaypalAccounts < ActiveRecord::Migration
  def change
    create_table :organization_paypal_accounts do |t|
    	t.integer :user_id
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :name
    	t.string :email
    	t.string :first_name
    	t.string :last_name
    	t.string :location
    	t.string :phone
    	t.string :token
    	t.string :refresh_token
    	t.string :expires_at
    	t.boolean :expires
    	t.string :account_creation_date
    	t.string :account_type
    	t.string :user_identity
    	t.string :country
    	t.string :locality
    	t.string :postal_code
    	t.string :region
    	t.string :street_address
    	t.string :language
    	t.string :locale
    	t.boolean :verified_account
    	t.string :zoneinfo
    	t.string :age_range
    	t.string :birthday
    	t.integer :retry
    	t.string :uid 
    	t.integer :organization_id
    	t.integer :organization_application_id
      t.timestamps
    end
  end
end
