class ActivityRemoveDraft < ActiveRecord::Migration
  def change
  	remove_column :activities, :draft
  end
end
