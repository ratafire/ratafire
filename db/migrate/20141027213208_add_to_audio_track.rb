class AddToAudioTrack < ActiveRecord::Migration
  def up
  	add_column :audios, :default_image, :integer, :default => 0
  end

  def down
  end
end
