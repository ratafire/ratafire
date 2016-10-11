class AddRewadIdToTransaction < ActiveRecord::Migration
  def change
  	add_column :transactions, :reward_id, :integer
  end
end
