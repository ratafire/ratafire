class AddExploreFundableWeight < ActiveRecord::Migration
  def up
  	add_column :users, :explore_fundable_weight, :integer
  end

  def down
  end
end
