class AddToVideos < ActiveRecord::Migration
  def up
  	add_column :videos, :processed, :boolean,:default => false, :null => false
  	add_column :videos, :user_id, :integer,:null => false
   	add_column :artworks, :direct_upload_url, :string, :null => false
  	add_column :artworks, :processed, :boolean,:default => false, :null => false 
  	add_column :artworks, :user_id, :integer,:null => false	
   	add_column :icons, :direct_upload_url, :string, :null => false
  	add_column :icons, :processed, :boolean,:default => false, :null => false 
  	add_column :icons, :user_id, :integer,:null => false
  	add_index  :videos, :user_id
  	add_index :videos, :processed
  	add_index :artworks, :user_id
  	add_index :artworks, :processed
  	add_index :icons, :user_id
  	add_index :icons, :processed	  	
  end

  def down
  end
end
