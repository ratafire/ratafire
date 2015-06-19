class AddMaskedToUser < ActiveRecord::Migration
  def change
  	add_column :users, :masked, :boolean
  end
end
