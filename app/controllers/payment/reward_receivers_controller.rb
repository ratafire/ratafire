class Payment::RewardReceiversController < ApplicationController

	layout 'studio'

	before_filter :load_reward_receiver, only:[:request_shipping_fee]
	before_filter :load_user, only:[:request_shipping_fee, :confirm_payment, :ship_reward, :ship_reward_now]
	before_filter :load_shipping_order, only:[:confirm_payment]

	#noREST Methods -----------------------------------	

	# confirm_payment_user_payment_reward_receivers POST
	# /users/:user_id/payment/reward_receivers/:shipping_order_id/confirm_payment
	def confirm_payment
		if @shipping_order.transacted
			redirect_to(:back)
		else
			if @shipping_order.update(
				status: 'Started'
			)
				confirm_shipping_payment
			else
				flash[:error] = t('errors.messages.not_saved')
				redirect_to(:back)
			end
		end
	end

	# cancel_payment_user_payment_reward_receivers DELETE
	# /users/:user_id/payment/reward_receivers/:shipping_order_id/cancel_payment
	def cancel_payment
	end

	# ship_reward_user_payment_reward_receivers GET
	# /users/:user_id/payment/reward_receivers/:reward_receiver_id/ship_reward
	def ship_reward
		@reward_receiver = RewardReceiver.find(params[:reward_receiver_id])
		@reward = Reward.find(@reward_receiver.reward_id)
	end

	#This is the actual action that ships the reward
	# ship_reward_now_user_payment_reward_receivers POST
	def ship_reward_now
		@reward_receiver = RewardReceiver.find(params[:reward_receiver_id])
		@reward_receiver.update(reward_receiver_params)
		if @reward_receiver.update(
			status: "shipped"
		)
		#Send email
		#Send notification
		end
		redirect_to show_user_studio_rewards_path(@reward_receiver.reward.user_id,@reward_receiver.reward_id)
	end

	# reward_receiver_router_user_payment_reward_receivers GET
	# /users/:user_id/payment/reward_receivers/:reward_receiver_id/:reward_receiver_router/reward_receiver_router
	#def reward_receiver_router
	#	case params[:reward_receiver_router]
	#	when 'request_shipping_fee'
	#		redirect_to request_shipping_fee_user_payment_reward_receivers_path(params[:user_id], params[:reward_receiver_id])
	#	end
	#end

	# request_shipping_fee_user_payment_reward_receivers GET
	# /users/:user_id/payment/reward_receivers/:reward_receiver_id/request_shipping_fee
	def request_shipping_fee
		@reward = Reward.find(@reward_receiver.reward_id)
		@amount = @reward.shippings.where(country: @reward_receiver.shipping_address.country).first.amount
		if @shipping_order = ShippingOrder.find_by_reward_receiver_id(@reward_receiver.id)
		else
			@shipping_order = ShippingOrder.create(
				user_id: @reward_receiver.user_id,
				amount: @amount,
				currency: @reward.currency,
				status: 'Sent',
				country: @reward_receiver.shipping_address.country,
				city: @reward_receiver.shipping_address.city,
				line1: @reward_receiver.shipping_address.line1,
				postal_code: @reward_receiver.shipping_address.postal_code,
				state: @reward_receiver.shipping_address.state,
				name: @reward_receiver.shipping_address.name,
				reward_id: @reward_receiver.reward_id,
				reward_receiver_id: @reward_receiver.id,
				due: 30.days.from_now
			)
		end
		@reward_receiver.update(
			status: 'shipping_fee_request_sent'
		)
		#Send order email
        Payment::ShippingOrdersMailer.send_confirmation(shipping_order_id: @shipping_order.id).deliver_now
		#Send order notification
		Notification.create(
			user_id: @reward_receiver.user_id,
            trackable_id: @shipping_order.id,
            trackable_type: "ShippingOrder",
            notification_type: "send_shipping_order_confirmation"
		)
		redirect_to(:back)
	end

private

	def load_reward_receiver
		@reward_receiver = RewardReceiver.find(params[:reward_receiver_id])
	end

	def load_user
		@user = User.find(params[:user_id])
	end

	def load_shipping_order
		@shipping_order = ShippingOrder.find(params[:shipping_order_id])
	end

	def confirm_shipping_payment
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
				amount: @shipping_order.amount.to_i*100,
				currency: @shipping_order.reward.currency,
				customer: @subscriber.customer.customer_id,
				description: I18n.t('views.payment.backs.ratafire_payment'),
				destination: @subscribed.stripe_account.stripe_id
			)
		rescue
			@shipping_order.update(
				status: 'Error'
			)
			flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
			redirect_to how_i_get_paid_user_studio_wallets_path(@subscriber.username)	
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
				@transfer = Transfer.create(
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
				status: 'ready_to_ship'
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
			redirect_to thankyou_user_payment_confirm_payments_path(@user.id)
		else
			@shipping_order.update(
				status: 'Error'
			)		
			flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
			redirect_to how_i_get_paid_user_studio_wallets_path(@subscriber.username)			
		end
	rescue
		@shipping_order.update(
			status: 'Error'
		)		
		flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
		redirect_to how_i_get_paid_user_studio_wallets_path(@subscriber.username)	
	end

	def reward_receiver_params
		params.require(:reward_receiver).permit(:shipping_company, :tracking_number)
	end

end