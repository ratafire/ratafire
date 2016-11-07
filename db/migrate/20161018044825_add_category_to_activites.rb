class AddCategoryToActivites < ActiveRecord::Migration
  def change
  	add_column :activities, :category, :string
  	add_column :activities, :sub_category, :string
  end
end
