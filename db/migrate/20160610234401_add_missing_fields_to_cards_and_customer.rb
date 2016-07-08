class AddMissingFieldsToCardsAndCustomer < ActiveRecord::Migration
  def change
  	add_column :cards, :card_number, :string
  	add_column :cards, :encrypted_card_number, :string 
  	add_column :cards, :encrypted_card_number_iv, :string
  	add_column :cards, :encrypted_exp_month, :string
  	add_column :cards, :encrypted_exp_month_iv, :string
  	add_column :cards, :encrypted_exp_year, :string
  	add_column :cards, :encrypted_exp_year_iv, :string
  	add_column :cards, :cvc, :string
  	add_column :cards, :encrypted_cvc, :string
  	add_column :cards, :encrypted_cvc_iv, :string
  	add_column :cards, :encrypted_address_zip, :string
  	add_column :cards, :encrypted_address_zip_iv, :string
  	add_column :bank_accounts, :encrypted_postal_code, :string
  	add_column :bank_accounts, :encrypted_postal_code_iv, :string
  end
end
