class AddPublishedAtToActivities < ActiveRecord::Migration
	def up
    	add_column :activities, :published, :boolean, :default => true
  	end

  	def down
    	remove_column :activities, :published
  	end
end
