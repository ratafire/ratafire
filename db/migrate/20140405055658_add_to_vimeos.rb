class AddToVimeos < ActiveRecord::Migration
  def up
  	add_column :vimeos, :oauth_token, :string
  	add_column :vimeos, :oauth_secret, :string
  	add_column :vimeos, :link, :string
  	add_column :vimeos, :nickname, :string
  	add_column :vimeos, :uid, :string
  	add_column :vimeos, :name, :string
  	add_column :vimeos, :description, :text
  	add_column :vimeos, :image, :string
  end

  def down
  end
end
