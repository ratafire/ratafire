class AddDescriptionToTags < ActiveRecord::Migration
  def change
  	add_column :tags, :description, :text
  	add_column :tags, :uuid, :string
  	add_column :tags, :direct_upload_url, :string
  	add_column :tags, :processed, :boolean, :default => false, :null => false
  	add_attachment :tags, :image
  end
end
