class UpdateProjectComment < ActiveRecord::Migration
  def up
  	add_column :project_comments, :stars, :integer, :default => 0
  	add_column :project_comments, :title, :string
  end

  def down
  end
end
