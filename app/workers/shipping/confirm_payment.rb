class Shipping::ConfirmPayment

	#Charge the subscriber
	@queue = :shipping

	def self.perform(shipping_order_id)
		@shipping_order = ShippingOrder.find(shipping_order_id)
		@subscriber = User.find(@shipping_order.user_id)
		@subscribed = User.find(@shipping_order.reward.user_id)
		@subscription = Subscription.find(@shipping_order.reward_receiver.subscription_id)
		if @subscriber.try(:locale)
			I18n.locale = @subscriber.locale
		end	
		#Pay through Stripe
		begin
			#Connect to Stripe
			if Rails.env.production?
				Stripe.api_key = ENV['STRIPE_SECRET_KEY']
			else
				Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
			end
			response = Stripe::Charge.create(
				amount: @shipping_order.amount*100,
				currency: @shipping_order.reward.currency,
				customer: @subscriber.customer.customer_id,
				description: I18n.t('views.payment.backs.ratafire_payment'),
				destination: @subscribed.stripe_account.stripe_id
			)
		rescue
			@shipping_order.update(
				status: 'Error'
			)
		end
		if response.captured == true
			#Record transaction
			@transaction = Transaction.prefill!(
				response,
				:shipping_order_id => @shipping_order.id,
				:subscriber_id => @subscriber.id,
				:fee => @shipping_order.amount.to_f*0.029+0.30,
				:transaction_method => "Stripe",
				:currency => @shipping_order.reward.currency,
				:subscribed_id => @subscribed.id,
				:transaction_type => 'Shipping',
				:reward_id => @shipping_order.reward.id
			)
			@transaction = Transaction.find_by_shipping_order_id(@shipping_order.id)
			#Record transfer
			if @subscribed.transfer != nil then
				@transfer = @subscribed.transfer
				@transfer.update(
					user_id: @subscribed.id,
					method: 'Stripe',
					collected_amount: @transfer.collected_amount+@shipping_order.amount,
					collected_fee: @transfer.collected_fee+@transaction.fee,
					collected_receive: @transfer.collected_receive+@transaction.receive,
				)
				@transaction.update(
					transfer_id: @transfer.id
				)
			else
				if @transfer = Transfer.create(
					user_id: @subscribed.id,
					method: 'Stripe',
					collected_amount: @transfer.collected_amount+@shipping_order.amount,
					collected_fee: @transfer.collected_fee+@transaction.fee,
					collected_receive: @transfer.collected_receive+@transaction.receive,
				)
					@transaction.update(
						transfer_id: @transfer.id
					)		
				end	
			end
			#Subscription Record
			@subscription_record = SubscriptionRecord.find(@subscription.subscription_record_id)
			if @subscription_record == nil then	
				@subscription_record = SubscriptionRecord.create(
					subscriber_id: @subscription.subscriber_id,
					subscribed_id: @subscription.subscribed_id,
					accumulated_total: @shipping_order.amount,
					accumulated_receive: ( @shipping_order.amount - @transaction.fee),
					accumulated_fee: @transaction.fee
				)
			else
				@subscription_record.update(
					accumulated_total: @subscription_record.accumulated_total+@shipping_order.amount,
					accumulated_receive: @subscription_record.accumulated_receive+( @shipping_order.amount - @transaction.fee),
					accumulated_fee: @subscription_record.accumulated_fee+@transaction.fee
				)
			end	
			#Get reward
			@shipping_order.reward_receiver.update(
				statsu: 'ready_to_ship'
			)
			#Subscription
			@subscription.update(
				accumulated_total: @subscription.accumulated_total+@shipping_order.amount,
				accumulated_receive: @subscription.accumulated_receive+( @shipping_order.amount - @transaction.fee ),
				accumulated_fee: @subscription.accumulated_fee+@transaction.fee,
				subscription_record_id: @subscription_record.id
			)
			#Record shipping order
			@shipping_order.update(
				transacted: true,
				transacted_at: Time.now
			)
			#Send email
			Payment::SubscriptionsMailer.transaction_confirmation(transaction_id: @transaction.id).deliver_now
			#Send notification to subscribed
			Notification.create(
				user_id: @subscriber.id,
				trackable_id: @transaction.id,
				trackable_type: "Transaction",
				notification_type: "receipt"
			)
		end
	end

end