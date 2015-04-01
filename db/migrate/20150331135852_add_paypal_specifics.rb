class AddPaypalSpecifics < ActiveRecord::Migration
  def up
  	add_column :transactions, :paypal_correlation_id, :string
  	add_column :transactions, :billing_agreement_id, :string
  	add_column :transactions, :paypal_transaction_id, :string
  end

  def down
  end
end
