class CreateSubscriptionErrors < ActiveRecord::Migration
  def change
    create_table :subscription_errors do |t|
    	t.string :uuid
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.integer :subscription_id
    	t.integer :subscriber_id
    	t.integer :subscribed_id
    	t.integer :subscription_record_id
    	t.integer :order_id
    	t.integer :order_subset_id
    	t.integer :transaction_id
    	t.integer :transaction_subset_id
    	t.integer :transfer_id
    	t.integer :transfer_subset_id
    	t.integer :error_code
      t.timestamps null: false
    end
  end
end
