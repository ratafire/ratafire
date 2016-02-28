class UserLocation < ActiveRecord::Migration
  def change
  	remove_column :users, :location
  	add_column :users, :country, :string
  	add_column :users, :state, :string
  	add_column :users, :city, :string
  end
end
