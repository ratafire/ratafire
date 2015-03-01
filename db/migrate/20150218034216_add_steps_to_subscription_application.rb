class AddStepsToSubscriptionApplication < ActiveRecord::Migration
  def change
  	add_column :subscription_applications, :step, :integer
  end
end
