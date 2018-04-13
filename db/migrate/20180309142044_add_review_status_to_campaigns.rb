class AddReviewStatusToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :review_status, :string
  end
end
