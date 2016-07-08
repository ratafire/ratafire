class AddShippingCountryToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :shipping_country, :string
  end
end
