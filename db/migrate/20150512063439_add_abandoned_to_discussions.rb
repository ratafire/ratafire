class AddAbandonedToDiscussions < ActiveRecord::Migration
  def change
  	add_column :discussions, :abandoned, :boolean
  	add_column :majorposts, :abandoned, :boolean
  end
end
