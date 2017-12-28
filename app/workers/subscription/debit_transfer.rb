class Subscription::ConfirmPayment
	#Charge the subscriber
	@queue = :subscription

	def self.perform(balance_transaction_id)
		if @balance_transaction = BalanceTransaction.find(balance_transaction_id)
			if @balance_transaction.amount < 0
				begin
					#Connect to Stripe
					if Rails.env.production?
						Stripe.api_key = ENV['STRIPE_SECRET_KEY']
					else
						Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
					end					
					#Create a transfer from a connected account
					
				rescue
					#Order subset error unsubscribe
					order_subset.update(
						status: 'Error'
					)
					@order.update(
						status: 'Error'
					)
				end
			end
		end
	end

end