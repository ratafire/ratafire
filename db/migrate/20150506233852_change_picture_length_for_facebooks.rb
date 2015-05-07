class ChangePictureLengthForFacebooks < ActiveRecord::Migration
  def up
  	add_attachment :facebookupdates, :facebookimage
  end

  def down
  end
end
