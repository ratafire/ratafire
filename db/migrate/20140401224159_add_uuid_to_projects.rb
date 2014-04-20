class AddUuidToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :uuid, :string
    add_column :majorposts, :uuid, :string
  end
end
