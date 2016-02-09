class AddSkipEverafterToProfilephoto < ActiveRecord::Migration
  def change
  	add_column :profilephotos, :skip_everafter, :boolean
  end
end
