class AddLikersAndWatchers < ActiveRecord::Migration
  def up
  	add_column :liked_projects, :liker_id, :integer
  	add_column :watcheds, :watcher_id, :integer
  end

  def down
  end
end
