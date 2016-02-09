class AddUuidToArtworks < ActiveRecord::Migration
  def up
  	add_column :artworks, :uuid, :string
  end
  def down
  	remove_column :artworks, :uuid
  end  
end
