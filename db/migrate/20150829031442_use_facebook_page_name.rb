class UseFacebookPageName < ActiveRecord::Migration
  def up
  	add_column :users, :masked, :boolean
  	add_column :users, :memorized_fullname, :string
  end

  def down
  end
end
