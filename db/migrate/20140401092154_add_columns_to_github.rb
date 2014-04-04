class AddColumnsToGithub < ActiveRecord::Migration
  def change
  	add_column :twitters, :nickname, :string
  	add_column :githubs, :uid, :string
  	add_column :githubs, :email, :string
  	add_column :githubs, :image, :string
  	add_column :githubs, :link, :string
  	add_column :githubs, :oauth_token, :string
  	add_column :githubs, :username, :string
  	add_column :githubs, :name, :string
  	add_column :githubs, :hireable, :string
  	add_column :githubs, :public_repos, :string
  end
end
