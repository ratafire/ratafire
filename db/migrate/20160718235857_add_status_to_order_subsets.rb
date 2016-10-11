class AddStatusToOrderSubsets < ActiveRecord::Migration
  def change
  	add_column :order_subsets, :status, :string
  end
end
