class AddPostTypeToMajorposts < ActiveRecord::Migration
  def change
  	add_column :majorposts, :post_type, :string, :default => "text"
  end
end
