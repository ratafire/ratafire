class AddContentUpdatedAtToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :content_updated_at, :datetime
  end
end
