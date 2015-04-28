class RenameVenmosToUserVenmos < ActiveRecord::Migration
  def up
  	rename_table :venmos, :user_venmos
  end

  def down
  end
end
