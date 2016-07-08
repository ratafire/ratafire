class CreateRewardReceivers < ActiveRecord::Migration
  def change
    create_table :reward_receivers do |t|
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.integer :user_id
    	t.integer :campaign_id
    	t.integer :reward_id
    	t.integer :subscription_id
    	t.integer :subscription_record_id
    	t.boolean :default
    	t.boolean :shipping_paid
    	t.boolean :status
    	t.string :tracking_number
    	t.string :shipping_company
      t.timestamps null: false
    end
  end
end
