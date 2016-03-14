class AddDefaultToCampaignsDuration < ActiveRecord::Migration
  def change
  	change_column :campaigns, :duration, :integer, :default => 1
  end
end
