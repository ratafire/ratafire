class RateAverage < ActiveRecord::Migration
  def up
  	add_column :rating_caches, :star_1_qty, :integer, :default => 0
  	add_column :rating_caches, :star_1_per, :float, :default => 0.0
  	add_column :rating_caches, :star_2_qty, :integer, :default => 0
  	add_column :rating_caches, :star_2_per, :float, :default => 0.0  	
  	add_column :rating_caches, :star_3_qty, :integer, :default => 0
  	add_column :rating_caches, :star_3_per, :float, :default => 0.0  
  	add_column :rating_caches, :star_4_qty, :integer, :default => 0
  	add_column :rating_caches, :star_4_per, :float, :default => 0.0  
  	add_column :rating_caches, :star_5_qty, :integer, :default => 0
  	add_column :rating_caches, :star_5_per, :float, :default => 0.0    	
  end

  def down
  end
end
