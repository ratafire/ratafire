class AddAbandonedToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :abandoned, :boolean
  end
end
