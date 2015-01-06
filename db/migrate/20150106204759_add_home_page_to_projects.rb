class AddHomePageToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :featured_home, :boolean, :default => false
  end
end
