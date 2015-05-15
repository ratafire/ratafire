class AddFeaturedToManyModels < ActiveRecord::Migration
  def change
  	add_column :majorposts, :featured_home, :default => false
  	add_column :discussions, :featured_home, :default => false
  	add_column :projects, :listed, :boolean
  	add_column :majorposts, :listed, :boolean
  	add_column :discussions, :listed, :boolean
  	add_column :facebookupdates, :listed, :boolean
  end
end
