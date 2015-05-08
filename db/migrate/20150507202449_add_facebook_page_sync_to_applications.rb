class AddFacebookPageSyncToApplications < ActiveRecord::Migration
  def change
  	add_column :subscription_applications, :facebookpage_id, :integer
  end
end
