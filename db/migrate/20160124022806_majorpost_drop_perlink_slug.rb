class MajorpostDropPerlinkSlug < ActiveRecord::Migration
	def up
    	remove_column :majorposts, :perlink
    	remove_column :majorposts, :slug
  	end

  	def down
    	add_column :majorposts, :perlink, :string
    	add_column :majorposts, :slug, :string
  	end
end
