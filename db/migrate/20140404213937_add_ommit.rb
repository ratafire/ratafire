class AddOmmit < ActiveRecord::Migration
  def up
  	add_column :beta_users, :ignore, :boolean
  end

  def down
  end
end
