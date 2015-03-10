class LinkRatingCacheToProjects < ActiveRecord::Migration
  def up
  	add_column :rating_caches, :project_id, :integer
  end

  def down
  end
end
