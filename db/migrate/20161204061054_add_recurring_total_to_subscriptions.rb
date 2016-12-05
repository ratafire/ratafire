class AddRecurringTotalToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :campaigns, :recurring_total, :decimal, :precision => 10, :scale => 2, :default => 0
  	add_column :rewards, :recurring_total, :decimal, :precision => 10, :scale => 2, :default => 0
  	add_column :majorposts, :recurring_total, :decimal, :precision => 10, :scale => 2, :default => 0
  end
end
