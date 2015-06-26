class AddOrganizationIdToIcons < ActiveRecord::Migration
  def change
  	add_column :icons, :organization_id, :integer
  	add_column :icons, :organization_application_id, :integer
  end
end
