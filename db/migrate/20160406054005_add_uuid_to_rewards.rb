class AddUuidToRewards < ActiveRecord::Migration
  def change
  	add_column :rewards, :uuid, :string
  end
end
