class ChangeDirectUploadUrlToNotNull < ActiveRecord::Migration
  def change
  	change_column :audios, :direct_upload_url, :string, :null => true
  end
end
