class CreateStripeAccounts < ActiveRecord::Migration
  def change
    create_table :stripe_accounts do |t|
    	t.integer :user_id
    	t.string :uuid
    	t.string :stripe_id
    	t.boolean :deleted
    	t.datetime :deleted_at
    	t.string :object
    	t.string :business_name
    	t.string :business_primary_color
    	t.string :business_url
    	t.boolean :charges_enabled
    	t.string :country
    	t.boolean :debit_negative_balances
    	t.boolean :avs_failure
    	t.boolean :cvc_failure
    	t.string :default_currency
    	t.boolean :details_submitted
    	t.string :display_name
    	t.string :email
    	t.string :city
    	t.string :line1
    	t.string :line2
    	t.string :postal_code
    	t.string :state
    	t.string :town
    	t.string :personal_id_number_provided
    	t.string :phone_number
    	t.string :ssn_last_4_provided
    	t.string :account_type
    	t.string :verification_details
    	t.string :verification_details_code
    	t.string :verification_document
    	t.string :verification_status
    	t.boolean :managed
    	t.string :product_description
    	t.string :statement_descriptor
    	t.string :support_email
    	t.string :support_phone
    	t.string :support_url
    	t.string :timezone
    	t.string :tos_acceptance_date
    	t.string :tos_acceptance_ip
    	t.string :tos_acceptance_user_agent
    	t.integer :transfer_schedule_delay_days
    	t.string :transfer_schedule_interval
    	t.string :transfer_schedule_monthly_anchor
    	t.string :weekly_anchor
    	t.boolean :transfers_enabled
    	t.string :verification_disabled_reason
    	t.string :verification_due_by
    	t.text :verification_fields_needed
      t.timestamps null: false
    end
  end
end
