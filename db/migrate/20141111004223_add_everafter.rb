class AddEverafter < ActiveRecord::Migration
  def up
  	add_column :videos, :skip_everafter, :boolean, :default => false
  	add_column :icons, :skip_everafter, :boolean, :default => false
  	add_column :artworks, :skip_everafter, :boolean, :default => false
  	add_column :audios, :skip_everafter, :boolean, :default => false
  end

  def down
  end
end
