class AddMajorpostIdToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :majorposts, :subscription_id, :integer
  end
end
