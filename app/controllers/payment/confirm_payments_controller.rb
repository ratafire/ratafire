class Payment::ConfirmPaymentsController < ApplicationController

	before_filter :load_subscriber, only:[:create]

	#REST Methods -----------------------------------
	# user_payment_confirm_payments POST
	# /users/:user_id/payment/confirm_payments
	def create
		if @order = @subscriber.order
			#Transact the order
			transact_through_stripe
			redirect_to(:back)
		end
	end	

private

	def transact_through_stripe
		begin
			response = Stripe::Charge.create(
				:amount => @order.amount.to_i*100,
				:currency => "usd",
				:customer => @subscriber.customer.customer_id,
				:description => t('views.payment.backs.ratafire_payment')
			)
		rescue
			flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
			redirect_to(:back)
		end
		if response.captured == true
			#Record transaction
			@transaction = Transaction.prefill!(
				response,
				:order_id => @order.id,
				:subscriber_id => @subscriber.id,
				:fee => @order.amount.to_f*0.029+0.30,
				:transaction_method => "Stripe",
				:currency => "usd"
			)
			#Record transfer
			@fee = @transaction.fee / @order.count if @order.count != 0
			@subscriber.reverse_subscriptions.each do |subscription| 
				subscribed = User.find(subscription.subscribed_id)
				#Create transaction detail
				@transaction_subset = TransactionSubset.create(
					campaign_id: @subscribed.try(:active_campaign).try(:id),
					transaction_id: @transaction.id,
					user_id: @subscriber.id,
					subscriber_id: @subscriber.id,
					subscribed_id: subscribed.id,
					updates: 0,
					currency: 'usd',
					amount: subscription.amount,
					description: t('mailer.payment.subscription.receipt.support') + subscription.subscribed.preferred_name
				)
				if subscribed != nil && subscribed.transfer != nil then
					#If the subscribed has order this month
					if subscribed.transfer.ordered_amount != 0 then
						#Transfer
						transfer = subscribed.transfer
						transfer.update(
							collected_receive: transfer.collected_receive+( subscription.amount - @fee),
							collected_amount: transfer.collected_amount+subscription.amount,
							collected_fee: transfer.collected_fee+@fee
						)
						#Subscription Record
						subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
						if subscription_record == nil then	
							subscription_record = SubscriptionRecord.create(
								subscriber_id: subscription.subscriber_id,
								subscribed_id: subscription.subscribed_id,
								accumulated_total: subscription.amount,
								accumulated_receive: ( subscription.amount - @fee),
								accumulated_fee: @fee,
								counter: subscription_record.counter+1
							)
						else
							subscription_record.update(
								accumulated_total: subscription_record.accumulated_total+subscription.amount,
								accumulated_receive: subscription_record.accumulated_receive+( subscription.amount - @fee),
								accumulated_fee: subscription_record.accumulated_fee+@fee,
								counter: subscription_record.counter+1
							)
						end
						#Subscription
						subscription.update(
							accumulated_total: subscription.accumulated_total+subscription.amount,
							accumulated_receive: subscription.accumulated_receive+( subscription.amount - @fee ),
							accumulated_fee: subscription.accumulated_fee+@fee,
							counter: subscription.counter+1,
							subscription_record_id: subscription_record.id
						)
					end
				end
			end
			#Record Order
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
			Payment::SubscriptionsMailer.transaction_confirmation(transaction_id: @transaction.id).deliver_now
			#Send notification to subscribed
			Notification.create(
				user_id: @subscriber.id,
				trackable_id: @transaction.id,
				trackable_type: "Transaction",
				notification_type: "receipt"
			)
		else
			flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
			redirect_to(:back)
		end
	end

	def load_subscriber
		@subscriber = User.find(params[:user_id])
	end

	def connect_to_stripe
		if Rails.env.production?
			Stripe.api_key = ENV['STRIPE_SECRET_KEY']
		else
			Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
		end
	end

end