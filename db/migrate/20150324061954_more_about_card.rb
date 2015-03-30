class MoreAboutCard < ActiveRecord::Migration
  def up
  	add_column :cards, :last4, :string
  	add_column :cards, :brand, :string
  	add_column :cards, :funding, :string
  	add_column :cards, :exp_month, :string  
  	add_column :cards, :exp_year, :string  		
  	add_column :cards, :fingerprint, :string  	  	
  	add_column :cards, :country, :string  	
  	add_column :cards, :name, :string  	
  	add_column :cards, :address_line1, :string  	
  	add_column :cards, :address_line2, :string  	
  	add_column :cards, :address_city, :string  	
  	add_column :cards, :address_state, :string  	
  	add_column :cards, :address_zip, :string  	
  	add_column :cards, :address_country, :string  	
  end

  def down
  end
end
