class AddMorethingsToRecipients < ActiveRecord::Migration
  def change
  	add_column :recipients, :tax_id, :string
  	add_column :recipients, :email, :string
  	add_column :recipients, :name, :string
  	add_column :recipients, :verified, :boolean
  	add_column :recipients, :country, :string
  	add_column :recipients, :routing_number, :string
  	add_column :recipients, :account_number, :string
  	add_column :recipients, :last4, :string
  	add_column :recipients, :exp_mongth, :string
  	add_column :recipients, :exp_year, :string
  	add_column :recipients, :cvc, :string
  	add_column :recipients, :card_name, :string
  	add_column :recipients, :address_line1, :string
  	add_column :recipients, :address_line2, :string
  	add_column :recipients, :address_city, :string
  	add_column :recipients, :address_zip, :string
  	add_column :recipients, :address_state, :string
  	add_column :recipients, :address_country, :string
  	add_column :recipients, :description, :string
  end
end
