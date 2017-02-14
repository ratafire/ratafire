class Stripe::Events

	#Temporarily replaces webhook
	@queue = :stripe

	def self.perform
		#Connect to stripe
		if Rails.env.production?
			Stripe.api_key = ENV['STRIPE_SECRET_KEY']
		else
			Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
		end
		#Set the timestamp 
		@timestamp = (Time.now - 20.days).to_i
		#Retrive events
		if @events = Stripe::Event.list('created[gte]' => @timestamp)
			#Deal with each event
			@events.data.all.each do |event|
				case event.data.object.object
				when 'transfer'
					if @transfer = Transfer.find_by_stripe_transfer_id(event.data.object.id)
						Transfer.update_transfer(event.data.object)
					else
						Transfer.create_transfer(event.data.object)
					end
				else
					if @stripe_account = StripeAccount.find_by_stripe_id(event.data.object.id)
						StripeAccount.stripe_account_update(event.data.object, @stripe_account.user_id)
					end
				end
			end
		end
	end

end