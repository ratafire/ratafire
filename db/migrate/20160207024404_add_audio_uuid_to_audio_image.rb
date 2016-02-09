class AddAudioUuidToAudioImage < ActiveRecord::Migration
  def change
  	add_column :audio_images, :audio_uuid, :string
  	add_column :audio_images, :majorpost_uuid, :string
  end
end
