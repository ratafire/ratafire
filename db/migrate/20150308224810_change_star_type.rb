class ChangeStarType < ActiveRecord::Migration
  def up
  	change_column :ratings, :stars, :float, :default => 0
  end

  def down
  end
end
