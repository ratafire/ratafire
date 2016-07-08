class AddAppliedAtToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :applied_at, :datetime
  end
end
