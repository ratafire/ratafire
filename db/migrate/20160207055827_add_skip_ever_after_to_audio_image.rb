class AddSkipEverAfterToAudioImage < ActiveRecord::Migration
  def change
  	add_column :audio_images, :skip_everafter, :boolean
  end
end
