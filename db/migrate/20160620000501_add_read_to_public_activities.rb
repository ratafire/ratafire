class AddReadToPublicActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :read, :boolean
  end
end
