class AddHtmlDisplayToFacebook < ActiveRecord::Migration
  def change
  	add_column :facebookupdates, :html_display, :text
  	add_column :facebookupdates, :realm, :string
  	add_column :facebookupdates, :sub_realm, :string
  	add_column :facebookupdates, :featured, :boolean, :default => false
  	add_column :facebookupdates, :featured_home, :boolean, :default => false
  	add_column :activities, :listed, :boolean
  	add_column :activities, :reviewed, :boolean 
  end
end
