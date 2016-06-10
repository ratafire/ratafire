class AddFullNameToIdentityVerification < ActiveRecord::Migration
  def change
  	add_column :identity_verifications, :first_name, :string
  	add_column :identity_verifications, :last_name, :string
  end
end
