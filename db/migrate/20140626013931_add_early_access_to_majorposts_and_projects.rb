class AddEarlyAccessToMajorpostsAndProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :early_access, :boolean, :default => false
  	add_column :majorposts, :early_access, :boolean, :default => false
  end
end
