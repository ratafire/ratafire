class AddAudioId < ActiveRecord::Migration
  def up
  	add_column :projects, :audio_id, :integer
  	add_column :majorposts, :audio_id, :integer
  end

  def down
  end
end
