class ChangeMajorpostDefaultPublishedAt < ActiveRecord::Migration
	def up
    	change_column_default :majorposts, :published, :true
  	end

  	def down
    	change_column_default :majorposts, :published, nil
  	end
end
