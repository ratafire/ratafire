class AddDirectUploadUrlToRewards < ActiveRecord::Migration
  def change
  	add_column :rewards, :direct_upload_url, :string
  end
end
