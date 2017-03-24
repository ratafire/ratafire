class AddMajorpostIdToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :majorpost_id, :integer
  end
end
