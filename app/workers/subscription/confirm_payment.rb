class Subscription::ConfirmPayment
	#Charge the subscriber
	@queue = :subscription

	def self.perform(order_id)
		if @order = Order.find(order_id)
			@subscriber = User.find(@order.user_id)
			if @subscriber.try(:locale)
				I18n.locale = @subscriber.locale
			end	
			@order.order_subsets.each do |order_subset|
				begin
					@subscribed = User.find(order_subset.subscribed_id)
					@subscription = Subscription.find(order_subset.subscription_id)
					#Connect to Stripe
					if Rails.env.production?
						Stripe.api_key = ENV['STRIPE_SECRET_KEY']
					else
						Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
					end
					begin
						response = Stripe::Charge.create(
							amount: order_subset.amount.to_i*100,
							currency: @subscription.currency,
							customer: @subscriber.customer.customer_id,
							description: I18n.t('views.payment.backs.ratafire_payment'),
							destination: @subscribed.stripe_account.stripe_id
						)
					rescue
						#Order subset error unsubscribe
						order_subset.update(
							status: 'Error'
						)
						Subscription.unsubscribe(reason_number: 3, subscriber_id:@subscriber.id, subscribed_id: @subscribed.id)
					end
					if response.captured == true
						#Record transaction
						if @transaction = Transaction.find_by_order_id(@order.id)
							@transaction.update(
								total: @transaction.total+response.amount.to_f/100,
								fee: @transaction.fee+order_subset.amount.to_f*0.029+0.30
							)
						else
							@transaction = Transaction.prefill!(
								response,
								:order_id => @order.id,
								:subscriber_id => @subscriber.id,
								:fee => order_subset.amount.to_f*0.029+0.30,
								:transaction_method => "Stripe",
								:currency => "usd",
								:subscribed_id => @subscribed.id
							)
						end
						@fee = order_subset.amount.to_f*0.029+0.30
						#Record transaction_subset
						@transaction_subset = TransactionSubset.create(
							campaign_id: @subscribed.try(:active_campaign).try(:id),
							transaction_id: @transaction.id,
							user_id: @subscriber.id,
							subscriber_id: @subscriber.id,
							subscribed_id: @subscribed.id,
							updates: 0,
							currency: 'usd',
							amount: order_subset.amount,
							description: I18n.t('mailer.payment.subscription.receipt.support') + @subscribed.preferred_name
						)
						#Record transfer
						if @subscribed.try(:transfer).try(:ordered_amount) != 0
							@transfer = @subscribed.transfer
							@transfer.update(
								collected_receive: transfer.collected_receive+( order_subset.amount - @fee),
								collected_amount: transfer.collected_amount+order_subset.amount,
								collected_fee: transfer.collected_fee+@fee
							)
						end
						#Subscription Record
						@subscription_record = SubscriptionRecord.find(@subscription.subscription_record_id)
						if @subscription_record == nil then	
							@subscription_record = SubscriptionRecord.create(
								subscriber_id: @subscription.subscriber_id,
								subscribed_id: @subscription.subscribed_id,
								accumulated_total: @subscription.amount,
								accumulated_receive: ( @subscription.amount - @fee),
								accumulated_fee: @fee,
								counter: @subscription_record.counter+1,
								credit: @subscription.amount
							)
						else
							@subscription_record.update(
								accumulated_total: @subscription_record.accumulated_total+@subscription.amount,
								accumulated_receive: @subscription_record.accumulated_receive+( @subscription.amount - @fee),
								accumulated_fee: @subscription_record.accumulated_fee+@fee,
								counter: @subscription_record.counter+1,
								credit: @subscription.credit+@subscription.amount
							)
						end
						#Campaign
						if @campaign = Campaign.find(@subscription.campaign_id)
							@campaign.update(
								accumulated_total: @campaign.accumulated_total+@transaction.total,
								accumulated_receive: @campaign.accumulated_total+@transaction.receive,
								accumulated_fee: @campaign.accumulated_fee+@transaction.fee
							)
						end
						#Get reward
						if @reward_receiver.find_by_subscription_id(@subscription.id)
							if @reward_receiver.status == 'waiting_for_payment'
								if @reward_receiver.amount > 0 
									@reward_receiver.update(
										paid: true,
										status: 'paid'
									)
								else
									if @reward_receiver.shipping_address
										@reward_receiver.update(
											paid: true,
											status: 'ready_to_ship'
										)
									else
										@reward_receiver.update(
											paid: true,
											status: 'paid'
										)
									end
								end
								@subscription_record.credit -= @subscribed.active_reward.amount
								@subscription_record.save
							end
						end
						#Subscription
						@subscription.update(
							accumulated_total: @subscription.accumulated_total+@subscription.amount,
							accumulated_receive: @subscription.accumulated_receive+( @subscription.amount - @fee ),
							accumulated_fee: @subscription.accumulated_fee+@fee,
							counter: @subscription.counter+1,
							subscription_record_id: @subscription_record.id
						)
					else
						#Order error unsubscribe
						order_subset.update(
							status: 'Error'
						)
						Subscription.unsubscribe(reason_number: 3, subscriber_id:@subscriber.id, subscribed_id: @subscribed.id)
					end
				end			
			end
			#Record order
			@order.update(
				transacted: true,
				transacted_at: Time.now
			)
			#Billing Subscription
			@billing_subscription = @subscriber.billing_subscription
			@billing_subscription.update(
				accumulated_total: @billing_subscription.accumulated_total+@transaction.total,
				accumulated_payment_fee: @billing_subscription.accumulated_payment_fee+@transaction.fee,
				accumulated_receive: @billing_subscription.accumulated_receive+@transaction.receive
			)	
			#Send email to subscribed
			if @transaction = Transaction.find_by_order_id(@order.id)
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
	#rescue
	end

end