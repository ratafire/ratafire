class AddMoreToFacebook < ActiveRecord::Migration
  def change
  	add_column :facebooks, :bio, :text
  	add_column :facebooks, :location, :string
  	add_column :facebooks, :website, :string
  	add_column :facebooks, :school, :string
  	add_column :users, :school, :string
  end
end
