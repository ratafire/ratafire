class RemoveProfilePhotoAttachment < ActiveRecord::Migration
  def change
  	drop_attached_file :users, :profilephoto
  end
end
