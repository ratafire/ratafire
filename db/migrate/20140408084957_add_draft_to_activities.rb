class AddDraftToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :draft, :boolean
  end
end
