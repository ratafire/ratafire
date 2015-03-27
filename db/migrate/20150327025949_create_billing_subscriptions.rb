class CreateBillingSubscriptions < ActiveRecord::Migration
  def change
    create_table :billing_subscriptions do |t|
      t.integer :user_id
      t.integer :count
      t.decimal :accumulated_receive, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :accumulated_payment_fee, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :accumulated_ratafire, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :accumulated_total, :precision => 10, :scale => 2, :default => 0.0
      t.boolean :deleted
      t.datetime :deleted_at
      t.datetime :this_billing_date
      t.datetime :next_billing_date
      t.datetime :prev_billing_date
      t.decimal :this_amount, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :next_amount, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :next_amount, :precision => 10, :scale => 2, :default => 0.0
      t.integer :retry
      t.string :uuid
      t.boolean :activated
      t.datetime :activated_at
      t.timestamps
    end
    add_column :transactions, :payment_fee, :decimal,:precision => 10, :scale => 2, :default => 0.0
    add_column :transactions, :billing_subscription_id, :integer
    add_column :transactions, :billing_artist_id, :integer
  end
end
