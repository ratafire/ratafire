class AddReviewdToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :test, :boolean, :default => false
  	add_column :campaigns, :reviewed_at, :datetime
  	add_column :campaigns, :reviewed, :boolean
  end
end
