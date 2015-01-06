class AddFeaturedHomeToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :featured_home, :boolean, :default => false
  end
end
