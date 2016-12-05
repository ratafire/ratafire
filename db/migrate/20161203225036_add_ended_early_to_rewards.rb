class AddEndedEarlyToRewards < ActiveRecord::Migration
  def change
  	add_column :rewards, :ended_early, :boolean
  	add_column :rewards, :ended_early_at, :datetime
  end
end
