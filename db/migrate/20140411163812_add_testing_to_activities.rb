class AddTestingToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :test, :boolean, :default => false
  end
end
