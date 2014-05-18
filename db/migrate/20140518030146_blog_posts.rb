class BlogPosts < ActiveRecord::Migration
  def up
  	add_column :blogposts, :deleted, :boolean,:default => false
  	add_column :blogposts, :featured, :boolean
  	add_column :blogposts, :published, :boolean
  end

  def down
  end
end
