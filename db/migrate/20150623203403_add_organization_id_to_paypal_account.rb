class AddOrganizationIdToPaypalAccount < ActiveRecord::Migration
  def change
  	add_column :paypal_accounts, :organization_id, :integer
  	add_column :paypal_accounts, :organization_application_id, :integer
  end
end
