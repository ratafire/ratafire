class AddDeletedAtToSocialMedia < ActiveRecord::Migration
  def change
  	add_column :twitters, :deleted, :boolean
  	add_column :twitters, :deleted_at, :datetime
  	add_column :githubs, :deleted, :boolean
  	add_column :githubs, :deleted_at, :datetime
  	add_column :deviantarts, :deleted, :boolean
  	add_column :deviantarts, :deleted_at, :datetime
  	add_column :vimeos, :deleted, :boolean
  	add_column :vimeos, :deleted_at, :datetime
  end
end
