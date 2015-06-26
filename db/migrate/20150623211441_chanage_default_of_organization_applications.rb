class ChanageDefaultOfOrganizationApplications < ActiveRecord::Migration
  def up
  	add_column :organizations,:goal_subscription_amount, :integer, :default => 7730
  	add_column :organization_applications, :goal_subscription_amount, :integer, :default => 7730
  end

  def down
  end
end
