class AddAbandonedToProjects < ActiveRecord::Migration
  def change
  	add_column :campaigns, :abandoned, :boolean
  	add_column :campaigns, :abandoned_at, :datetime
  	remove_column :campaigns, :subcategory
  end
end
