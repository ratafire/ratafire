class AddPrevToTutorials < ActiveRecord::Migration
  def change
  	add_column :tutorials, :profile_tutorial_prev, :integer
  	add_column :tutorials, :project_tutorial_prev, :integer
  end
end
