class AddStatusToOrganizationApplication < ActiveRecord::Migration
  def change
  	add_column :organization_applications, :status, :string
  	add_column :organization_applications, :deleted, :boolean
  	add_column :organization_applications, :deleted_at, :datetime
  end
end
