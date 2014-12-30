class AddProfileDirectUploadToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :direct_upload_url, :string
  	add_column :users, :processed, :boolean, :default => false
  	add_column :users, :skip_everafter, :default => false
  end
end
