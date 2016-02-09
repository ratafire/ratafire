class ChangeArtworkDirectUploadUrlToNull < ActiveRecord::Migration
  def up
  	change_column :artworks, :direct_upload_url, :string, :null => true
  end
  def down
  	change_column :artworks, :direct_upload_url, :string, :null => false
  end
end
