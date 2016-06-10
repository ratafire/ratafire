class AddUuidToIdentityVerification < ActiveRecord::Migration
  def change
  	add_column :identity_verifications, :uuid, :string
  end
end
