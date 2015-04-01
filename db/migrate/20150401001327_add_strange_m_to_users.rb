class AddStrangeMToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :after_subscription_url, :string
  	add_column :users, :signup_during_subscription, :boolean, :default => false
  end
end
