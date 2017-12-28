class AddObjectToBalanceTransaction < ActiveRecord::Migration
  def change
  	add_column :balance_transactions, :stripe_object, :string
  end
end
