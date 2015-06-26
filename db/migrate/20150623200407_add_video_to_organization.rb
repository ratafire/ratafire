class AddVideoToOrganization < ActiveRecord::Migration
  def change
  	add_column :videos, :organization_application_id, :integer
  	add_column :organizations, :perlink, :string
  end
end
