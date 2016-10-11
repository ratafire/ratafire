class AddDirectUploadUrlToRewardUploads < ActiveRecord::Migration
  def change
  	add_column :reward_uploads, :direct_upload_url, :string
  end
end
