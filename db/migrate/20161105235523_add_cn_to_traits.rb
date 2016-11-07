class AddCnToTraits < ActiveRecord::Migration
  def change
  	add_column :traits, :zh_cn, :string
  	add_column :traits, :uuid, :string
  end
end
