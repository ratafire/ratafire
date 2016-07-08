class AddFundingTypeToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :funding_type, :string
  end
end
