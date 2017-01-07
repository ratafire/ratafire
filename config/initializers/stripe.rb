if Rails.env.production?
	Stripe.api_key = ENV['STRIPE_SECRET_KEY']
else
	Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
end
# STRIPE_WEBHOOK_SECRET environment variable
#StripeEvent.authentication_secret = ENV['STRIPE_WEBHOOK_SECRET']

StripeEvent.configure do |events|

	#Account
	events.subscribe 'account.updated' do |event|
		if @stripe_account = StripeAccount.find_by_stripe_id(event.data.object.id)
			StripeAccount.stripe_account_update(event.data.object, @stripe_account.user_id)
		end
	end

	#Charge
	#events.subscribe 'charge.failed' do |event|
		#if the charge failed
	#	Transaction.failed_transaction(event.data.object)
	#end	

	#Cutomer
	#events.subscribe 'customer.updated' do |event|
	#end

	#Source
	#events.subscribe 'source.failed' do |event|
	#end

	#Transfer
	events.subscribe 'transfer.updated' do |event|
		Transfer.update_transfer(event.data.object)
	end

	#events.all do |event|
	# Handle all event types - logging, etc.
	#end
end