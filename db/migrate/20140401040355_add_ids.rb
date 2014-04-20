class AddIds < ActiveRecord::Migration
  def up
  	add_column :twitters, :user_id, :integer
  	add_column :githubs, :user_id, :integer
  	add_column :deviantarts, :user_id, :integer
  	add_column :vimeos, :user_id, :integer
  end

  def down
  end
end
