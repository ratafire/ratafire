class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.boolean :deleted
      t.datetime :deleted_at
      t.string :uuid
      t.integer :subscriber_id
      t.integer :subscribed_id
      t.integer :subscription_id
      t.integer :transaction_id
      t.string :stripe_refund_id
      t.integer :stripe_amount
      t.decimal :amount, precision: 10, scale: 2
      t.string :stripe_charge_id
      t.string :stripe_balance_transaction
      t.datetime :stripe_created
      t.string :currency
      t.string :reason
      t.string :stripe_receipt_number
      t.string :stripe_status
      t.timestamps null: false
    end
  end
end
