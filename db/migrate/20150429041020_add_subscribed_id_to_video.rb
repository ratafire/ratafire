class AddSubscribedIdToVideo < ActiveRecord::Migration
  def change
  	add_column :videos, :subscribed_id, :integer
  end
end
