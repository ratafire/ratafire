class AddPublishedAtToMajorposts < ActiveRecord::Migration
  def change
  	add_column :majorposts, :published_at, :datetime
  	add_column :projects, :published_at, :datetime
  end
end
