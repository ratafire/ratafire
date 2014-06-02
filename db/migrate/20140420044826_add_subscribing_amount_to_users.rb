class AddSubscribingAmountToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :subscribing_amount, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end
end
