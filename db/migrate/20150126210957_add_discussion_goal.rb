class AddDiscussionGoal < ActiveRecord::Migration
  def up
  	add_column :discussions, :goal, :integer
  end

  def down
  end
end
