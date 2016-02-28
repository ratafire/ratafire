class SoundcloundExpires < ActiveRecord::Migration
  def change
  	remove_column :soundcloud_oauths, :expires
  	add_column :soundcloud_oauths, :expires, :boolean
  	add_column :soundcloud_oauths, :refresh_token, :string
  end
end
