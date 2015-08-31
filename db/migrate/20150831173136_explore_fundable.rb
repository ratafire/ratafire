class ExploreFundable < ActiveRecord::Migration
  def up
  	add_column :users, :explore_fundable, :boolean
  end

  def down
  end
end
