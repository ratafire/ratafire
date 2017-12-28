class CreateDisputeEvidences < ActiveRecord::Migration
  def change
    create_table :dispute_evidences do |t|
      t.string :uuid
      t.integer :subscriber_id
      t.integer :subscribed_id
      t.integer :subscription_id
      t.integer :dispute_id
      t.integer :reward_id
      t.boolean :deleted
      t.datetime :deleted_at
      t.string :access_activity_log
      t.string :billing_address
      t.string :cancellation_policy
      t.string :cancellation_policy_disclosure
      t.string :cancellation_rebuttal
      t.string :customer_communication
      t.string :customer_email_address
      t.string :customer_name
      t.string :customer_purchase_ip
      t.string :customer_signature
      t.string :duplicate_charge_documentation
      t.string :duplicate_charge_explanation
      t.string :duplicate_charge_id
      t.string :product_description
      t.string :receipt
      t.string :refund_policy
      t.string :refund_policy_disclosure
      t.string :refund_refusal_explanation
      t.string :service_date
      t.string :service_documentation
      t.string :shipping_address
      t.string :shipping_carrier
      t.string :shipping_date
      t.string :shipping_documentation
      t.string :shipping_tracking_number
      t.string :uncategorized_file
      t.string :uncategorized_text
      t.timestamps null: false
    end
    add_column :disputes, :due_by, :datetime
    add_column :disputes, :has_evidence, :boolean
    add_column :disputes, :past_due, :boolean
    add_column :disputes, :submission_count, :integer
    add_column :disputes, :reward_id, :integer
  end
end
