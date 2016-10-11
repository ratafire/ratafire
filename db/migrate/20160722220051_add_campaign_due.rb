class AddCampaignDue < ActiveRecord::Migration
  def change
  	add_column :campaigns, :due, :datetime
  end
end
