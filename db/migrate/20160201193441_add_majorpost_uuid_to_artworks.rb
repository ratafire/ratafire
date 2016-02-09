class AddMajorpostUuidToArtworks < ActiveRecord::Migration
  def up
  	add_column :artworks, :majorpost_uuid, :string
  end
  def down
  	remove_column :artworks, :majorpost_uuid
  end
end
