class AddPaidCreationToMajorposts < ActiveRecord::Migration
  def up
  	add_column :majorposts, :paid_update, :boolean, :default => false
  end
  def down
  	remove_column :majorposts, :paid_updates
  end  
end
