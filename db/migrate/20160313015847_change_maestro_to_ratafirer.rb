class ChangeMaestroToRatafirer < ActiveRecord::Migration
  def change
  	remove_column :campaigns, :maestro
  	add_column :campaigns, :ratafirer, :boolean, :default => false
  end
end
