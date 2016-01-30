class ChangeActivityDefault < ActiveRecord::Migration
	def up
    	change_column_default :activities, :draft, :false
  	end

  	def down
    	change_column_default :activities, :draft, nil
  	end
end
