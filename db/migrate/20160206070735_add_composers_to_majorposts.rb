class AddComposersToMajorposts < ActiveRecord::Migration
  def change
  	add_column :majorposts, :composer, :string
  	add_column :majorposts, :artist, :string
  end
end
