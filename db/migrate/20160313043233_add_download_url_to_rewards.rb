class AddDownloadUrlToRewards < ActiveRecord::Migration
  def change
  	remove_column :rewards, :at_stock
  	add_column :rewards, :in_stock, :boolean, :default => false
  	add_column :rewards, :download_url, :string
  end
end
