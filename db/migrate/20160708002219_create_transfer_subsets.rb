class CreateTransferSubsets < ActiveRecord::Migration
  def change
    create_table :transfer_subsets do |t|
    	t.boolean :deleted
    	t.datetime :deleted_at
        t.integer :subscriber_id
        t.integer :subscribed_id
    	t.integer :user_id
    	t.integer :transaction_id
    	t.decimal :collected_amount, :precision => 10, scale: 2
    	t.string :description
    	t.integer :updates
    	t.string :currency
    	t.integer :subscription_id
    	t.integer :subscription_record_id
    	t.integer :transfer_id
        t.string :uuid
        t.decimal :collected_fee, :precision => 10, scale: 2
        t.decimal :collected_receive, :precision => 10, scale: 2
      t.timestamps null: false
    end
  end
end
