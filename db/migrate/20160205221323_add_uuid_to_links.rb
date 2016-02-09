class AddUuidToLinks < ActiveRecord::Migration
  def change
  	add_column :links, :uuid, :string
  end
end
