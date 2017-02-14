class AddBackersOnlyToMajorposts < ActiveRecord::Migration
  def change
  	add_column :majorposts, :backers_only, :boolean
  end
end
