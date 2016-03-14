class CleanUpUser < ActiveRecord::Migration
  def change
  	remove_column :users, :goals_subscribers
  	remove_column :users, :goals_monthly
  	remove_column :users, :goals_project
  	remove_column :users, :provider
  	remove_column :users, :goals_updated_at
  	remove_column :users, :bio_html
  	remove_column :users, :subscription_status_initial
  	remove_column :users, :legalname
  	remove_column :users, :signup_during_subscription
  	remove_column :users, :homepage_fundable
  	remove_column :users, :fundable_show
  	remove_column :users, :goals_watching
  	remove_column :users, :goals_reviews
  	remove_column :users, :post_to_facebook
  	remove_column :users, :subscription_inactive
  	remove_column :users, :default_billing_method
  	remove_column :users, :subscription_switch
  	remove_column :users, :memorized_fullname
  	remove_column :users, :homepage_fundable_weight
  	remove_column :users, :explore_fundable
  	remove_column :users, :explore_fundable_weight
  end
end
