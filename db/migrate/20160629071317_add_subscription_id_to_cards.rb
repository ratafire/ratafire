class AddSubscriptionIdToCards < ActiveRecord::Migration
  def change
  	add_column :cards, :subscription_id, :integer
  end
end
