class AddCurrencyToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :currency, :string
  end
end
