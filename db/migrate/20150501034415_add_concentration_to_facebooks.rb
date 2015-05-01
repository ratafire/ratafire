class AddConcentrationToFacebooks < ActiveRecord::Migration
  def change
  	add_column :facebooks, :concentration, :string
  	add_column :users, :concentration, :string
  end
end
