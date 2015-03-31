class AddMethodToThings < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :method, :string
  	add_column :transactions, :method, :string
  end
end
