class AddProcessedToProfilephoto < ActiveRecord::Migration
  def change
  	add_column :profilephotos, :processed, :boolean
  end
end
