class AddCurrencyToCurrentGoal < ActiveRecord::Migration
  def change
  	add_column :rewards, :currency, :string
  end
end
