class AddStripId < ActiveRecord::Migration
  def up
  	add_column :transactions, :stripe_id, :string
  	add_column :transactions, :description, :string
  end

  def down
  end
end
