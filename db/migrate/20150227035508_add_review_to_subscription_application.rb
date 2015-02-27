class AddReviewToSubscriptionApplication < ActiveRecord::Migration
  def change
  	add_column :reviews, :subscription_application_id, :integer
  end
end
