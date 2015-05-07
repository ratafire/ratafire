class AddUuidToFacebookPages < ActiveRecord::Migration
  def change
  	add_column :facebook_pages, :city, :string
  	add_column :facebook_pages, :country, :string
  	add_column :facebook_pages, :state, :string
  	add_column :facebook_pages, :link, :string
  	add_column :facebook_pages, :uuid, :string
  	add_attachment :facebook_pages, :facebookprofile
  end
end
