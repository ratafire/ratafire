class AddNameToShippingOrder < ActiveRecord::Migration
  def change
  	add_column :shipping_orders, :name, :string
  end
end
