class AddReturnPostIdToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :facebookupdate_id, :string
  	add_column :majorposts, :facebookupdate_id, :string
  	add_column :discussions, :facebookupdate_id, :string
  end
end
