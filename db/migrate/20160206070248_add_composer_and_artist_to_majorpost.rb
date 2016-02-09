class AddComposerAndArtistToMajorpost < ActiveRecord::Migration
  def change
  	#add_column :majorposts, :composer, :string
  	#add_column :majorposts, :artist, :string
  	add_column :audios, :composer, :string
  	add_column :audios, :artist, :string
  	add_column :audios, :title, :string
  end
end
