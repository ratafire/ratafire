class RemoveColumnRequestSourceFromCampaigns < ActiveRecord::Migration
  def change
  	remove_column :campaigns, :request_source
  end
end
