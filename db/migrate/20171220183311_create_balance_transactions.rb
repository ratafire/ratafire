class CreateBalanceTransactions < ActiveRecord::Migration
  def change
    create_table :balance_transactions do |t|
      t.boolean :deleted
      t.datetime :deleted_at
      t.integer :dispute_id
      t.string :stripe_balance_transaction_id
      t.decimal :amount, precision: 10, scale: 2
      t.integer :stripe_amount
      t.datetime :available_on
      t.datetime :stripe_created
      t.string :currency
      t.string :description
      t.integer :stripe_fee
      t.decimal :fee, precision: 10, scale: 2
      t.string :fee_description
      t.string :fee_type
      t.integer :stripe_net
      t.decimal :net, precision: 10, scale: 2
      t.string :source
      t.string :stripe_status
      t.string :stripe_type
      t.string :uuid
      t.timestamps null: false
    end
  end
end
