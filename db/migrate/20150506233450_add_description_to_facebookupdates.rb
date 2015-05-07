class AddDescriptionToFacebookupdates < ActiveRecord::Migration
  def change
    add_column :facebookupdates, :description, :text
  end
end
