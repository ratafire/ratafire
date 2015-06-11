class AddIdentificationToFacebookPages < ActiveRecord::Migration
  def change
  	add_column :facebook_pages, :project_facebook, :boolean, :default => true
  	add_column :facebookpages, :project_facebook, :boolean, :default => true
  	add_column :projects, :project_facebook, :boolean
  end
end
