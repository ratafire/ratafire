class AddPatronVideoIdToVideo < ActiveRecord::Migration
  def change
  	add_column :videos, :patron_video_id, :integer
  end
end
