class AddNameToTagImage < ActiveRecord::Migration
  def change
  	add_column :tag_images, :name, :string
  end
end
