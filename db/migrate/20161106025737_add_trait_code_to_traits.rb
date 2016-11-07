class AddTraitCodeToTraits < ActiveRecord::Migration
  def change
  	add_column :traits, :trait_code, :string
  end
end
