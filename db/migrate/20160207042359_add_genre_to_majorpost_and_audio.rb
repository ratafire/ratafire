class AddGenreToMajorpostAndAudio < ActiveRecord::Migration
  def change
  	add_column :majorposts, :genre, :string
  	add_column :audios, :genre, :string
  end
end
