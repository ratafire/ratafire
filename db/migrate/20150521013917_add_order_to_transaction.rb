class AddOrderToTransaction < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :order_id, :integer
  end
end
