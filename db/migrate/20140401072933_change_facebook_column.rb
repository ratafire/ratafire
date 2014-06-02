class ChangeFacebookColumn < ActiveRecord::Migration
  def up
  	add_column :facebooks, :image, :string
  end

  def down
  end
end
