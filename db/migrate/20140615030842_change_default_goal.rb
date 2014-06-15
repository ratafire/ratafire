class ChangeDefaultGoal < ActiveRecord::Migration
  def up
  	change_column :users, :goals_subscribers, :integer, :default => 256
  end

  def down
  end
end
