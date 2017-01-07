class AddStripeStatusToIdentityVerification < ActiveRecord::Migration
  def change
  	add_column :identity_verifications, :stripe_status, :string
  end
end
