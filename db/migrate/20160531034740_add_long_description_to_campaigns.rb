class AddLongDescriptionToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :content, :text
  end
end
