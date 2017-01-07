class AddAtiveToIdentityVerification < ActiveRecord::Migration
  def change
  	add_column :identity_verifications, :active, :boolean
  end
end
