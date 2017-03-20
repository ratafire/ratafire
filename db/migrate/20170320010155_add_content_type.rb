class AddContentType < ActiveRecord::Migration
  def change
  	add_column :users, :content_type, :string, :default => "user"
  	add_column :majorposts, :content_type, :string, :default => "majorpost"
  	add_column :campaigns, :content_type, :string, :default => "campaign"
  end
end
