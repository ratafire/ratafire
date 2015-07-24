class AddLicenseToProjectsMajorposts < ActiveRecord::Migration
  def change
  	add_column :projects, :license, :string 
  	add_column :majorposts, :license, :string
  end
end
