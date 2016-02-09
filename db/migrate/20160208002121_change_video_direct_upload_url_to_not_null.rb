class ChangeVideoDirectUploadUrlToNotNull < ActiveRecord::Migration
  def change
  	change_column :videos, :direct_upload_url, :string, :null => true
  end
end
