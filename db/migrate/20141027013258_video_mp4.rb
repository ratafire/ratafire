class VideoMp4 < ActiveRecord::Migration
  def up
  	add_column :videos, :output_url_mp4, :string
  end

  def down
  end
end
