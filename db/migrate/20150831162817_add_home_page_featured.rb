class AddHomePageFeatured < ActiveRecord::Migration
  def up
  	add_column :users, :homepage_fundable_weight, :integer
  end

  def down
  end
end
