class AddCustomerToSomething < ActiveRecord::Migration
  def change
  	add_column :transactions, :created, :string
  	add_column :transactions, :livemode, :boolean
  	add_column :transactions, :paid, :boolean 
  	add_column :transactions, :currency, :string  	 	
  	add_column :transactions, :refunded, :boolean 		
  	add_column :transactions, :card_stripe_id, :string 	  	  	
  	add_column :transactions, :customer_stripe_id, :string   	
  	add_column :transactions, :captured, :boolean
  	add_column :transactions, :balance_transaction, :string		
  	add_column :transactions, :failure_message, :string
  	add_column :transactions, :failure_code, :string
  	add_column :transactions, :amount_refunded, :decimal, :precision => 10, :scale => 2, :default => 0.0
  	add_column :transactions, :recipient_stripe_id, :string	 
  	add_column :transactions, :reversed, :boolean		
  	add_column :transactions, :klass, :string 	
  end
end
