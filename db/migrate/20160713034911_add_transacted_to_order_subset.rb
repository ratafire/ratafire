class AddTransactedToOrderSubset < ActiveRecord::Migration
  def change
  	add_column :order_subsets, :transacted, :boolean
  	add_column :order_subsets, :transacted_at, :datetime
  end
end
