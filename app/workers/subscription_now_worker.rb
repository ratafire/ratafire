class SubscriptionNowWorker
	@queue = :subscription_now_queue

	def self.perform(subscription_id,transaction_id)
		#Find Variables
		@subscription = Subscription.find(subscription_id)
		@subscribed = User.find(@subscription.subscribed_id)
		@subscriber = User.find(@subscription.subscriber_id)
		@transaction = Transaction.find_by_id(transaction_id)
		#Send messages to the subscribed
		#Mailing the sucess confirmation email to the subscriber
		SubscriptionMailer.transaction_confirmation(@transaction.id).deliver
		#Mailing the sucess confirmation email to the subscribed
		if @transaction.supporter_switch == false then 
			if @subscription.counter == 0 then 
				message_content = "Hi "+@subscribed.first_name+", I am now subscribing to you. Keep up the great work!"
				message_title = @subscriber.fullname + " subscribed to you for $"+@subscription.amount.to_s+"/m"
				receipt = @subscriber.send_message(@subscribed, message_content, message_title)				
				SubscriptionMailer.new_subscriber(@transaction.id,receipt.notification_id).deliver
			else
				SubscriptionMailer.transaction_confirmation_subscribed(@transaction.id).deliver
			end
		end	
		#Subscription Record
		@subscription_record = SubscriptionRecord.find_by_subscriber_id_and_subscribed_id(@subscription.subscriber_id,@subscription.subscribed_id)
		if @subscription_record == nil then
			#Create a new subscription record
			@subscription_record = SubscriptionRecord.new
			@subscription_record.subscriber_id = @subscription.subscriber_id
			@subscription_record.subscribed_id = @subscription.subscribed_id
			@subscription_record.supporter_switch = @subscription.supporter_switch
			@subscription_record.accumulated_total = @transaction.total
			@subscription_record.counter = @subscription_record.counter+1
			@subscription_record.save
		else
			#Update the subscription record
			@subscription_record.accumulated_total += @transaction.total
			@subscription_record.supporter_switch = @subscription.supporter_switch
			@subscription_record.counter = @subscription_record.counter+1
			@subscription_record.save
		end		
		#Subscription 
		@subscription.accumulated_total += @transaction.total
		@subscription.first_payment = true
		@subscription.first_payment_created_at = Time.now
		@subscription.counter = @subscription.counter+1
		@subscription.subscription_record_id = @subscription_record.id
		@subscription.save
		#Billing Subscription
		if @subscriber.billing_subscription == nil then
			#Create a new billing subscription
			@billing_subscription = BillingSubscription.new
			@billing_subscription.user_id = @subscriber.id
			@billing_subscription.accumulated_total = @transaction.total
			@billing_subscription.next_billing_date = Time.now.beginning_of_month.next_month + 6.day
			@billing_subscription.next_amount = @subscription.amount
			@billing_subscription.activated = true
			@billing_subscription.activated_at = Time.now
			@billing_subscription.save
		else
			#Update the old billing subscription
			@billing_subscription = @subscriber.billing_subscription
			@billing_subscription.accumulated_total += @transaction.total
			@billing_subscription.next_amount += @subscription.amount
			@billing_subscription.save
		end
		#Billing Artist
		if @subscribed.billing_artist == nil then
			#Create a new billing artist
			@billing_artist = BillingArtist.new
			@billing_artist.user_id = @subscribed.id
			@billing_artist.next_billing_date = Time.now.beginning_of_month.next_month + 27.day
			@billing_artist.next_amount = @transaction.receive
			@billing_artist.save
		else
			#Update the old billing artist
			@billing_artist = @subscribed.billing_artist
			@billing_artist.next_amount += @transaction.receive
			@billing_artist.save
		end
		#Unbomb the subscribed
		@subscription_application = @subscribed.approved_subscription_application
		if @subscription_application != nil then
			Resque.enqueue(SubscriptionUnbombWorker,@subscribed.id)
		end
	end
end		

#Depreciated Amazon Payments
#	def self.perform(uuid)
#		subscription = Subscription.find_by_uuid(uuid)
#		Resque.enqueue(TransactionWorker, subscription.id)
#	end