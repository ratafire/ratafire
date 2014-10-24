class AddFileInfoToAudio < ActiveRecord::Migration
  def change
  	add_attachment :audios, :audio
  end
end
