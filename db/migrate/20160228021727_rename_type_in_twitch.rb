class RenameTypeInTwitch < ActiveRecord::Migration
  def change
  	remove_column :twitches, :type
  	add_column :twitches, :account_type, :string
  end
end
