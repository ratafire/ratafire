class CreateSubscriptionApplications < ActiveRecord::Migration
  def change
    create_table :subscription_applications do |t|
      t.text :why
      t.text :plan
      t.text :different
      t.string :status
      t.integer :user_id
      t.timestamps
    end
  end
end
