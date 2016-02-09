class AddImageToAudios < ActiveRecord::Migration
  def change
  	add_attachment :audios, :image
  end
end
