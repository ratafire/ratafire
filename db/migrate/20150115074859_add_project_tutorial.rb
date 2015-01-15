class AddProjectTutorial < ActiveRecord::Migration
  def up
  	add_column :tutorials, :project_tutorial, :integer
  end

  def down
  end
end
