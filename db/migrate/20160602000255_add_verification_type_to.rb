class AddVerificationTypeTo < ActiveRecord::Migration
  def change
  	add_column :identity_verifications, :verification_type, :string
  	add_column :identity_verifications, :ssn_last4, :string
  	add_column :identity_verifications, :id_card_last4, :string
  	add_column :identity_verifications, :passport_last4, :string
  	add_column :identity_verifications, :drivers_license_last4, :string
  end
end
