class AddMoreCardInfo < ActiveRecord::Migration
  def up
  	add_column :cards, :cardno, :string
  	add_column :cards, :cardcvc, :string
  end

  def down
  end
end
