class AddFirstPayment < ActiveRecord::Migration
  def up
  	add_column :subscriptions, :first_payment, :boolean, :default => false
  	add_column :subscriptions, :first_payment_created_at, :datetime
  end

  def down
  end
end
