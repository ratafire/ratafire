class AddDisputedToModels < ActiveRecord::Migration
  def change
  	add_column :transactions, :disputed, :boolean
  	add_column :transactions, :disputed_at, :datetime
  	add_column :transactions, :dispute_id, :integer

  	add_column :reward_receivers, :disputed, :boolean
  	add_column :reward_receivers, :disputed_at, :datetime
  	add_column :reward_receivers, :dispute_id, :integer  

  	add_column :disputes, :reward_receiver_id, :integer	
  end
end
