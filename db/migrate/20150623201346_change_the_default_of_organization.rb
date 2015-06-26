class ChangeTheDefaultOfOrganization < ActiveRecord::Migration
  def up
  	remove_column :organization_applications, :step
  	add_column :organization_applications, :step, :integer, :default => 1
  end

  def down
  end
end
