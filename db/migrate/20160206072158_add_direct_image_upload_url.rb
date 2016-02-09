class AddDirectImageUploadUrl < ActiveRecord::Migration
  def change
  	add_column :audios, :direct_image_upload_url, :string
  end
end
