class AddDirectUploadUrlToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :direct_upload_url, :string
  end
end
