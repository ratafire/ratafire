class UserHaveToUpdateUsername < ActiveRecord::Migration
  def up
  	add_column :users, :need_username, :boolean, :default => false
  end

  def down
  end
end
