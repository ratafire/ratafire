class ChargesController < ApplicationController

	protect_from_forgery :except => [:add_a_recipient, :update_recipient]

	def new
	end

	#Add a card on stripe for future payment
	def add_a_card
		@customer = Customer.find_by_user_id(params[:id])
		if @customer != nil then
			#use the old customer
			customer = Stripe::Customer.retrieve(@customer.customer_id)
			#create a token for the card
			token = params[:stripeToken]
			r = customer.sources.create(:card => token)
			#if successful
			if r.id != nil then
				card = Card.prefill!(customer, params[:id], @customer.id)
				redirect_to(:back)
			else
				flash[:error] = "Fail to add a new card."
				redirect_to(:back)
			end
		else
			#Create a new customer
			# Get the credit card details submitted by the form
			token = params[:stripeToken]
			# Create a Customer
			customer = Stripe::Customer.create(
  				:source => token
			)
			#Add subscription to this customer if the customer subscribes to another customer
			# Save the customer
			@customer = Customer.prefill!(customer,params[:id])
			@customer = Customer.find_by_user_id(params[:id])
			# Save the customer's card in your database so you can use it later
			card = Card.prefill!(customer, params[:id], @customer.id)
			#Redirect
			redirect_to(:back)
		end	
	end

	#Remove a card
	def remove_a_card
		#Delete the card on Ratafire
		card = Card.find_by_customer_stripe_id(params[:id], :conditions => {:deleted => nil})
		if card != nil then
			card.deleted = true
			card.deleted_at = Time.now
			card.save
			#Retrieve the customer
			customer = Stripe::Customer.retrieve(params[:id])
			#Delete the card on Stripe
			customer.sources.retrieve(card.card_stripe_id).delete()		
			#Redirect
			redirect_to(:back)
		end
	rescue Stripe::InvalidRequestError => e
			flash[:error] = "Unsucessful."
			redirect_to(:back)		
	end

	#Add a recipient path
	def add_a_recipient
		#Make a call to Stripe to create a recipient
		recipient = Stripe::Recipient.create(
			:name => params[:legalname],
			:type => "individual",
			:tax_id => params[:ssn],
			:bank_account => {
				:country => "US",
				:routing_number => params[:routing_number],
				:account_number => params[:account_number]
			}
		)		
		@recipient = Recipient.prefill!(recipient,params[:id], params[:account_number], params[:ssn])	
		#Push the application to next step
		@subscription_application = SubscriptionApplication.find(params[:application_id])
		@subscription_application.step = 7
		@subscription_application.save
		redirect_to pending_subscription_path(params[:id], params[:application_id])

	rescue Stripe::InvalidRequestError => e
			flash[:error] = e.message
			redirect_to(:back)
	end

	#Update a recipient
	def update_recipient
		#Make a call to Stripe to retrieve recipient
		@user = User.find(params[:id])
		@recipient = @user.recipient
		if @recipient != nil then 
			recipient = Stripe::Recipient.retrieve(@recipient.recipient_id)
			recipient.active_account.routing_number = params[:routing_number]
			recipient.active_account.account_number = params[:account_number]
			r = recipient.save
			#If sucessful
			if r.verified == true then
				@recipient.account_number = recipient.active_account.last4
				@recipient.routing_number = recipient.active_account.routing_number
				flash[:success] = "Update sucessful."
				redirect_to(:back)
			else
				flash[:error] = "Update unsucessful."
			end
		else
			flash[:error] = "Update unsucessful."
			redirect_to(:back)
		end
	end

	#Add a card and subscribe
	def add_card_subscribe
		@subscription = Subscription.new(params[:subscription])
		#See if it is a support
		if @subscription.amount == ENV["PRICE_1"].to_f
			@subscription.supporter_switch = true
		end
		#Set basic info of the subscription
		@user = User.find(params[:id])
		@subscriber = User.find(@subscription.subscriber_id)
		@subscription.project_id = @user.projects.where(:published => true, :complete => false).first.id		
		#Adda card
		unless @user.subscribed_by?(@subscriber) || @subscriber.subscribed_by?(@user) then
			if @subscription.method == "Card" then
				stripe_add_card(@subscriber.id,params[:stripeToken])
				#Subscribe
			else
				@subscription.save
				create_request
				port = Rails.env.production? ? "" : ":3000"
				redirect_url = "#{request.scheme}://#{request.host}#{port}/"+@subscription.id.to_s+"/r/paypal/add_paypal_subscribe_success"
				failure_url = "#{request.scheme}://#{request.host}#{port}/"+@user.username
				payment_request = Paypal::Payment::Request.new(
		  			:billing_type  => "MerchantInitiatedBilling",
		  			# Or ":billing_type => :MerchantInitiatedBillingSingleAgreement"
		  			# Read official document for details
		  			:billing_agreement_description => "Pay Ratafire with PayPal"
				)
				response = @request.setup(
	  				payment_request,
	  				redirect_url,
	  				failure_url
				)
				redirect_to response.redirect_uri			
			end
		else
			flash[:success] = "Subscription failed."
			redirect_to subscribers_path(@user.id)				
		end
	end

	#Add paypal subscribe
	def add_paypal_subscribe
		create_request
		response = @request.agree! params[:token]
		if current_user != nil then
			#Find the user
			@user = User.find(current_user.id)
			#Destry existed paypal billing agreement
			if @user.billing_agreement != nil then
				@request.revoke! @billing_agreement.billing_agreement_id
				@user.billing_agreement.deleted = true
				@user.billing_agreement.save
			end
			#Create a new billing agreement
			@billing_agreement = BillingAgreement.prefill!(:user_id => @user.id, :billing_agreement_id => response.billing_agreement.identifier)
			@subscription = Subscription.find(params[:subscription_id])
			subscribe_for_user
		else
			@subscription = Subscription.find(params[:subscription_id])
			redirect_to user_path(@subscription.subscribed)
		end		
	end

	#User already has a card
	def with_card_subscribe
		@subscription = Subscription.new(params[:subscription])
		#See if it is a support
		if @subscription.amount == ENV["PRICE_1"].to_f
			@subscription.supporter_switch = true
		end
		#Set basic info of the subscription
		@user = User.find(params[:id])
		@subscriber = User.find(@subscription.subscriber_id)
		@subscription.project_id = @user.projects.where(:published => true, :complete => false).first.id		
		#Create subscription
		subscribe_for_user
	end

	def subscription_thank_you
		@subscription = Subscription.find(params[:subscription_id])
		@subscribed = User.find(@subscription.subscribed_id)
		@subscriber = User.find(@subscription.subscriber_id)
	end	

	#After a new user is created

private

	def stripe_add_card(user_id,stripeToken)
		@customer = Customer.find_by_user_id(user_id)
		if @customer != nil then
			#use the old customer
			customer = Stripe::Customer.retrieve(@customer.customer_id)
			#create a token for the card
			token = stripeToken
			r = customer.sources.create(:card => token)
			#if successful
			if r.id != nil && customer != nil then
				@card = Card.prefill!(customer, user_id, @customer.id)
				subscribe_for_user
			else
				flash[:error] = "Fail to add a new card."
				redirect_to(:back)
			end
		else
			#Create a new customer
			# Get the credit card details submitted by the form
			token = stripeToken
			# Create a Customer
			customer = Stripe::Customer.create(
  				:source => token
			)
			#Add subscription to this customer if the customer subscribes to another customer
			# Save the customer
			@customer = Customer.prefill!(customer,user_id)
			@customer = Customer.find_by_user_id(user_id)
			# Save the customer's card in your database so you can use it later
			card = Card.prefill!(customer, user_id, @customer.id)
			subscribe_for_user
		end			
	end

	def subscription_post_payment
		@user.subscription_amount = @user.subscription_amount + @subscription.amount
		@subscriber.subscribing_amount = @subscriber.subscribing_amount + @subscription.amount
		#Enqueue post processor for payments
		if @subscription.supporter_switch == true
			#Create Support
			@user.supporter_slot -= 1
		else
			#Create Subscription
			#For subscribed
			@activity = PublicActivity::Activity.new
			@activity.trackable_id = @subscription.id
			@activity.trackable_type = "Subscription"
			@activity.owner_id = @subscription.subscribed.id
			@activity.owner_type = "User"
			@activity.key = "subscription.create"
			@activity.save
			#For subscriber
			@activity = PublicActivity::Activity.new
			@activity.trackable_id = @subscription.id
			@activity.trackable_type = "Subscription"
			@activity.owner_id = @subscription.subscriber.id
			@activity.owner_type = "User"
			@activity.key = "subscription.create"
			@activity.save
		end
		@user.save
		@subscriber.save
		flash[:success] = "You subscribed to "+@subscription.subscribed.fullname+"!"
		redirect_to subscription_thank_you_path(@subscription.id)
	end

	def subscribe_for_user
		@subscribed = User.find(@subscription.subscribed.id)
		@subscriber = User.find(@subscription.subscriber.id)
		
			@subscription.activated = true
			@subscription.activated_at = Time.now
			if @subscription.save then
				#Make first payment
				if @subscriber.cards.first != nil || params[:method] == "Card" || @subscription.method == "Card" then
					subscribe_through_stripe
				else
					if @subscriber.billing_agreement != nil || params[:method] == "PayPal"  || @subscription.method == "Card" then
						subscribe_through_paypal
					end
				end
			else
				@subscription.destroy
				PublicActivity::Activity.find_all_by_trackable_id_and_trackable_type(@subscription.id,'Subscription').each do |activity|
					if activity != nil then 
						activity.deleted = true
						activity.deleted_at = Time.now
						activity.save
					end
				end	
				flash[:success] = "The subscription to "+@subscription.subscribed.fullname+" did not go through."
				redirect_to subscribers_path(@subscription.subscribed_id)		
			end	
	end

	def subscribe_through_stripe
		response = Stripe::Charge.create(
			:amount => @subscription.amount.to_i*100,
			:currency => "usd",
			:customer => @subscriber.customer.customer_id,
			:description => "Subscription fee to <%= @user.fullname %> on Ratafire."
		)
		if response.captured == true then
			transaction = Transaction.prefill!(
			response,
			:subscription_id => @subscription.id,
			:subscriber_id => @subscriber.id,
			:subscribed_id => @user.id,
			:supporter_switch => @subscription.supporter_switch
		)
		subscription_post_payment
		#Enqueue Post Processing
		Resque.enqueue(SubscriptionNowWorker,@subscription.id,transaction.id)
		else
			#Transaction failed
			flash[:error] = "Invalid payment method."
			redirect_to(:back)			
		end
	end

	def subscribe_through_paypal
		create_request
		response = @request.charge! @subscriber.billing_agreement.billing_agreement_id, @subscription.amount.to_i
		if response.ack == "Success" then
			transaction = Transaction.paypal!(
			response,
			:subscription_id => @subscription.id,
			:subscriber_id => @subscriber.id,
			:subscribed_id => @user.id,
			:supporter_switch => @subscription.supporter_switch
		)			
			subscription_post_payment
		else
			#Transaction failed
			flash[:error] = "Invalid payment method."
			redirect_to(:back)		
			Resque.enqueue(SubscriptionNowWorker,@subscription.id,transaction.id)		
		end
	end

	def create_request
		if Rails.env.development? then
			@request = Paypal::Express::Request.new(
  				:username   => ENV["PAYPAL_SANDBOX_USERNAME"],
  				:password   => ENV["PAYPAL_SANDBOX_PASSWORD"],
  				:signature  => ENV["PAYPAL_SANDBOX_SIGNATURE"]
			)	
		else
			@request = Paypal::Express::Request.new(
  				:username   => ENV["PAYPAL_USERNAME"],
  				:password   => ENV["PAYPAL_PASSWORD"],
  				:signature  => ENV["PAYPAL_SIGNATURE"]
			)				
		end	
	end	

end