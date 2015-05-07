class AddFacebookDelete < ActiveRecord::Migration
  def up
  	add_column :facebooks, :deleted, :boolean
  	add_column :facebooks, :deleted_at, :datetime
  end

  def down
  end
end
