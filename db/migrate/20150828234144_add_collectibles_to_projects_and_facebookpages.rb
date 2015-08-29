class AddCollectiblesToProjectsAndFacebookpages < ActiveRecord::Migration
  def change
  	add_column :projects, :collectible_20, :text
  	add_column :projects, :collectible_50, :text
  	add_column :projects, :collectible_100, :text
  	add_column :facebookpages, :collectible_20, :text
  	add_column :facebookpages, :collectible_50, :text
  	add_column :facebookpages, :collectible_100, :text
  end
end
