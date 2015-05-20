class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
    	t.integer :user_id
    	t.integer :subscription_id
    	t.integer :subscription_record_id
    	t.integer :billing_artist_id
    	t.integer :recipient_id
    	t.decimal :fee, :percision => 10, :scale => 2
    	t.decimal :receive, :percision => 10, :scale => 2
    	t.decimal :amout, :percision => 10, :scale => 2
    	t.datetime :transfered_at
    	t.string :status
    	t.integer :retry, :default => 0
    	t.text :statusmessage
    	t.string :uuid
    	t.string :error
    	t.boolean :transfered
    	t.string :paypal_correlation_id
    	t.string :billing_agreement_id
    	t.string :paypal_transaction_id
    	t.string :venmo_transaction_id
    	t.string :venmo_username
    	t.string :venmo_token
    	t.string :stripe_id
    	t.string :method
    	t.string :stripe_transfer_id
    	t.string :stripe_destination_id
    	t.text :test
    	t.string :stripe_recipient_id
    	t.string :stripe_balance_transaction_id
      t.timestamps
    end

    add_column :transactions, :transfer_id, :integer
    add_column :recipients, :transfer_id, :integer
  end
end
