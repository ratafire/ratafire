class CreateDisputes < ActiveRecord::Migration
  def change
    create_table :disputes do |t|
      t.string :uuid
      t.integer :subscriber_id
      t.integer :subscribed_id
      t.integer :subscription_id
      t.integer :transaction_id
      t.string :stripe_dispute_id
      t.string :stripe_balance_transaction_id
      t.integer :balance_transaction_id
      t.integer :stripe_amount
      t.decimal :amount, precision: 10, scale: 2
      t.string :stripe_charge_id
      t.datetime :stripe_created
      t.string :currency
      t.boolean :is_charge_refundable
      t.boolean :livemode
      t.string :reason
      t.string :stripe_status
      t.integer :dispute_evidence_id
      t.timestamps null: false
    end
  end
end
