class AddSyncToFacebookPages < ActiveRecord::Migration
  def change
  	add_column :facebook_pages, :sync, :boolean
  	add_column :facebookpages, :sync, :boolean
  end
end
