class AddValidUpdateToFacebookupdates < ActiveRecord::Migration
  def change
  	add_column :facebookupdates, :valid_update, :boolean, :default => true
  end
end
