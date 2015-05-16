class AddProjectIdToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :facebook_page_id, :integer
  end
end
