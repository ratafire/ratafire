class Change < ActiveRecord::Migration
  def up
  	change_column :facebooks, :oauth_expires_at, :string
  end

  def down
  end
end
