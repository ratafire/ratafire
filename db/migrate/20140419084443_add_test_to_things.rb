class AddTestToThings < ActiveRecord::Migration
  def change
  	add_column :projects, :test, :boolean, :default => false
  	add_column :majorposts, :test, :boolean, :default => false
  end
end
