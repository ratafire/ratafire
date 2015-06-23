class CreateOrganizationSubscriptions < ActiveRecord::Migration
  def change
    create_table :organization_subscriptions do |t|
      t.integer :organization_id
      t.integer :subscriber_id
      t.decimal :amount, :precision => 10, :scale => 2, :default => 0
      t.datetime :deleted_at
      t.decimal :accumulated_receive, :precision => 10, :scale => 2, :default => 0
      t.decimal :accumulated_total, :precision => 10, :scale => 2, :default => 0
      t.integer :subscription_record_id
      t.datetime :activated_at
      t.boolean :activated, :default => false
      t.boolean :deleted
      t.string :uuid
      t.integer :counter
      t.string :method
      t.decimal :accumulated_fee, :precision => 10, :scale => 2, :default => 0
      t.integer :deleted_reason
      t.timestamps
    end
  end
end
