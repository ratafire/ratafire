class AddMajorpostIdToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :majorpost_id, :integer
  	add_column :subscriptions, :real_deleted, :boolean
  end
end
