class CreateDebitTransfers < ActiveRecord::Migration
  def change
    create_table :debit_transfers do |t|
      t.string :uuid
      t.boolean :deleted
      t.datetime :deleted_at
      t.integer :user_id
      t.integer :subscription_id
      t.integer :subscription_record_id
      t.integer :dispute_id
      t.integer :balance_transaction_id
      t.string :stripe_id
      t.string :stripe_object
      t.integer :stripe_amount
      t.decimal :amount, precision: 10, scale: 2
      t.integer :stripe_amount_reversed
      t.decimal :amount_reversed, precision: 10, scale: 2
      t.string :stripe_balance_transaction_id
      t.string :currency
      t.string :description
      t.string :stripe_destination
      t.string :stripe_destination_payment
      t.string :livemode
      t.boolean :reversed
      t.string :stripe_source_transaction
      t.string :stripe_source_type
      t.string :stripe_transfer_group
      t.timestamps null: false
    end
  end
end
