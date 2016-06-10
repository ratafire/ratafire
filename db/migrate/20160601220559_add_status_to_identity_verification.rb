class AddStatusToIdentityVerification < ActiveRecord::Migration
  def change
  	add_column :identity_verifications, :status, :string
  	add_column :identity_verifications, :stripe_verified, :boolean
  	add_column :identity_verifications, :stripe_verification_status, :string
  end
end
