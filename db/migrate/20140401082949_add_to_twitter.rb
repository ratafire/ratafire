class AddToTwitter < ActiveRecord::Migration
  def up
  	add_column :twitters, :uid, :string
  	add_column :twitters, :name, :string
  	add_column :twitters, :image, :string
  	add_column :twitters, :location, :string
  	add_column :twitters, :description, :string
  	add_column :twitters, :link, :string
  	add_column :twitters, :oauth_token, :string
  	add_column :twitters, :oauth_secret, :string
  	add_column :twitters, :lang, :string
  	add_column :twitters, :followers_count, :integer
  	add_column :twitters, :entities, :string
  end

  def down
  end
end
