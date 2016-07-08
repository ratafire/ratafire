class Payment::SubscriptionsController < ApplicationController

	before_filter :load_subscriber, only:[:create, :unsub]
	before_filter :load_reverse_subscriber, only:[:destroy]
	before_filter :check_if_active_subscription, only: [:create]
	before_filter :connect_to_stripe, only:[:create]

	#REST Methods -----------------------------------	

	# user_payment_subscriptions POST
	# /users/:user_id/payment/subscriptions
	def create
		#Prepare the models
		@subscription = Subscription.new(
			campaign_id: @subscribed.active_campaign.id,
			shipping_country: params[:subscription][:shipping_country],
			get_reward: params[:subscription][:get_reward],
			funding_type: params[:subscription][:funding_type],
			amount: params[:subscription][:amount],
			subscriber_id: @subscriber.id,
			subscribed_id: @subscribed.id,
			currency: 'usd',
			campaign_funding_type: @subscribed.active_campaign.funding_type
		)
		if params[:subscription][:upper_limit]
			@subscription.upper_limit = params[:subscription][:upper_limit]
		end
		if params[:subscription][:cards_attributes]
			add_card
		end
		if params[:subscription][:shipping_addresses_attributes]
			add_shipping_address
		end
		#Charge if charge
		if @subscription.funding_type == 'one_time'
			#Charge the card now
			subscribe_through_stripe
		else
			#Do not charge the card
			subscription_post_payment
		end
	#rescue
	#	flash[:error] = t('errors.messages.not_saved')
	#	redirect_to(:back)
	end

	# user_payment_subscriptions DELETE
	# /users/:user_id/payment/subscriptions
	# user is the subscriber
	# current_user is the subscribed
	def destroy
		@subscription = Subscription.find_by_subscriber_id_and_subscribed_id(@subscriber.id, @subscribed.id)
		unsubscribe(2)
		flash[:success] = t('mailer.payment.subscription.stopped_backer') + @subscriber.preferred_name
		redirect_to(:back)
	rescue
		flash[:error] = t('errors.messages.not_saved')
		redirect_to(:back)		
	end

	#noREST Methods -----------------------------------	

	# unsub_user_payment_subscriptions DELETE
	# /users/:user_id/payment/subscriptions/unsub
	# current_user is the subscriber
	# user is the subscribed
	def unsub
		@subscription = Subscription.find_by_subscriber_id_and_subscribed_id(@subscriber.id, @subscribed.id)
		unsubscribe(1)
		flash[:success] = t('mailer.payment.subscription.stopped_backing') + @subscribed.preferred_name
		redirect_to(:back)
	rescue
		flash[:error] = t('errors.messages.not_saved')
		redirect_to(:back)		
	end

private

	def load_subscriber
		@subscribed = User.find_by_uid(params[:user_id])
		@subscriber = current_user
	end

	def load_reverse_subscriber
		@subscriber = User.find_by_uid(params[:user_id])
		@subscribed = current_user
	end

	def subscription_params
		params.permit(:amount, :funding_type)
	end

	def add_card
		@card = Card.new(
			user_id: @subscriber.id,
			name: params[:subscription][:cards_attributes].values.first[:name],
			exp_year: params[:subscription][:cards_attributes].values.first[:exp_year],
			exp_month: params[:subscription][:cards_attributes].values.first[:exp_month],
			card_number: params[:subscription][:cards_attributes].values.first[:card_number],
			cvc: params[:subscription][:cards_attributes].values.first[:cvc],
			country: params[:subscription][:cards_attributes].values.first[:country],
			address_zip: params[:subscription][:cards_attributes].values.first[:address_zip],
		)
		@card.last4 = @card.card_number.to_s.split(//).last(4).join("").to_s
		if @stripe_token = Stripe::Token.create(
				:card => {
					:number => @card.card_number,
					:exp_month => @card.exp_month,
					:exp_year => @card.exp_year,
					:cvc => @card.cvc
				},
			)
			if @subscriber.customer
				@customer = Stripe::Customer.retrieve(@subscriber.customer.customer_id)
				if @customer.sources.create(:source => @stripe_token)
					update_card
				else
					flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
					redirect_to(:back)
				end
			else
				if @customer = Stripe::Customer.create(
					:source => @stripe_token
					)
					@user_customer = Customer.prefill!(@customer, @subscriber.id)
					@user_customer = Customer.find_by_user_id(@subscriber.id)
					if @customer = Stripe::Customer.retrieve(@user_customer.customer_id)
						update_card
					else
						flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
						redirect_to(:back)
					end
				else
					flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
					redirect_to(:back)
				end
			end
		else
			redirect_to(:back)
		end
	end

	def update_card
		if @card.update(
			card_stripe_id: @customer.sources.first.id,
			brand: @customer.sources.first.brand,
			address_zip_check:  @customer.sources.first.address_zip_check,
			cvc_check:  @customer.sources.first.cvc_check,
			funding:  @customer.sources.first.funding,
			customer_stripe_id:  @customer.id
		)
			if @user.card
				#retrieve old and new stripe 
				@new_card = @customer.sources.retrieve(@card.card_stripe_id)
				#Make new as default
				@customer.default_source = @new_card.id
				@customer.save
				#delete old
				@old_card = @customer.sources.retrieve(@subscriber.card.card_stripe_id)
				@old_card.delete
				@user.card.destroy
			end
			@card.user_id = @subscriber.id
			@card.save
			#render js
		else
			redirect_to(:back)
		end
	rescue
		@subscriber.card.destroy
		@card.user_id = @subscriber.id
		@card.save
	end	

	def add_shipping_address
		@shipping_address = ShippingAddress.new(
			user_id: @subscriber.id,
			name: params[:subscription][:shipping_addresses_attributes].values.first[:name],
			country: params[:subscription][:shipping_country],
			city: params[:subscription][:shipping_addresses_attributes].values.first[:city],
			line1: params[:subscription][:shipping_addresses_attributes].values.first[:line1],
			postal_code: params[:subscription][:shipping_addresses_attributes].values.first[:postal_code],
		)
		@shipping_address.user_id = @subscriber.id
		if @shipping_address.country == "US"
			if @zipcodes = ZipCodes.identify(@shipping_address.postal_code)
				@shipping_address.state = @zipcodes[:state_code]
				update_shipping_address
			else
				flash[:error] = t('errors.messages.postal_code')
				redirect_to(:back)
			end
		else
			update_shipping_address
		end
	end

	def update_shipping_address
		if @shipping_address.save
		else
			flash[:error] = @shipping_address.errors.full_messages
			redirect_to(:back)
		end
	end	

	def subscribe_through_stripe
		begin
			response = Stripe::Charge.create(
				:amount => @subscription.amount.to_i*100,
				:currency => "usd",
				:customer => @subscriber.customer.customer_id,
				:description => "Subscription fee to <%= @subscribed.fullname %> on Ratafire."
			)
		rescue
			flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
			redirect_to(:back)	
		end
		if response.captured == true then
			@subscription.save
			#Create transaction
			@transaction = Transaction.prefill!(
			response,
			:user_id => @subscriber.id,
			:subscription_id => @subscription.id,
			:subscriber_id => @subscriber.id,
			:subscribed_id => @subscribed.id,
			:supporter_switch => @subscription.supporter_switch,
			:fee => @subscription.amount.to_f*0.029+0.30,
			:transaction_method => "Stripe",
			:currency => "usd"
			)
			#Create transaction detail
			@transaction_detail = TransactionSubset.create(
				transaction_id: @transaction.id,
				user_id: @subscriber.id,
				subscriber_id: @subscriber.id,
				subscribed_id: @subscribed.id,
				updates: '-',
				currency: 'usd',
				amount: @subscription.amount,
				description: t('mailer.payment.subscription.receipt.support') + @subscription.subscribed.preferred_name
			)
			subscription_post_payment
		else
			flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
			redirect_to(:back)	
		end
	end

	def subscription_post_payment
		if @subscription.save
			#Create activity
			subscription_update_activity
			#Mailing the sucess confirmation email to the subscriber
			if @transaction
				Payment::SubscriptionsMailer.transaction_confirmation(transaction_id: @transaction.id).deliver_now
			end
			#Send notification to the subscriber
			send_notification_to_the_subscriber
			#Send notification to the subscribed
			send_notification_to_the_subscribed
			#update subscription record
			subscription_update_subscription_record
			#update billing_subscription
			subscription_update_billing_subscription
			#Update billing artist
			subscription_update_billing_artist
			#Make a follower
			subscription_add_follower
			#Create receiver
			if @subscription.get_reward == 'on'
				subscription_create_receiver
			end
			#Create a find a transfer
			if @transaction
				subscription_create_or_find_a_transfer
			end
			#Unsubscribe the one time backer
			if @subscription.funding_type == 'one_time'
				unsubscribe(8)
			else
				@subscription.update(
					activated: true
				)
			end
			redirect_to profile_url_path(@subscribed.username)
		else
			flash['error'] = @subscription.errors.full_messages
			redirect_to(:back)
		end
	#rescue
	end

	def subscription_update_user_display_amount
		@subscribed.subscription_amount = @subscribed.subscription_amount + @subscription.amount
		@subscriber.subscribing_amount = @subscriber.subscribing_amount + @subscription.amount
	end

	def subscription_update_activity
		@activity = PublicActivity::Activity.create(
			trackable_id: @subscription.id,
			trackable_type: "Subscription",
			owner_id: @subscription.subscribed.id,
			owner_type: "User",
			key: "subscription.create",
			)
		@activity = PublicActivity::Activity.create(
			trackable_id: @subscription.id,
			trackable_type: "Subscription",
			owner_id: @subscription.subscriber.id,
			owner_type: "User",
			key: "subscription.create",
			)
	end

	def subscription_create_receiver
		if @shipping_address
			create_reward_receiver
		else
			if @shipping_address = ShippingAddress.find_by_user_id_and_country(@subscriber.id, params[:subscription][:shipping_country])
				create_reward_receiver
			else
				flash[:error] = t('errors.messages.not_saved')
				redirect_to(:back)
			end
		end
	end

	def create_reward_receiver
		if @reward_receiver = RewardReceiver.create(
			user_id: @subscriber.id,
			reward_id: @subscribed.active_reward.id,
			subscription_id: @subscription.id,
			campaign_id: @subscribed.active_campaign.id,
			shipping_address_id: @shipping_address
		)
			if @transaction
				@reward_receiver.update(
					paid: true
				)
				@subscription_record.credit -= @subscribed.active_reward.amount
				@subscription_record.save
			end
		end
	end

	def send_notification_to_the_subscriber
		if @subscription.funding_type == 'one_time'
			Notification.create(
				user_id: @subscriber.id,
				trackable_id: @subscription.id,
				trackable_type: "Subscription",
				notification_type: "subscriber_one_time"
			)
		else
			Notification.create(
				user_id: @subscriber.id,
				trackable_id: @subscription.id,
				trackable_type: "Subscription",
				notification_type: "subscriber_recurring"
			)
		end
	end

	def send_notification_to_the_subscribed
		if @subscription.funding_type == 'one_time'
			Notification.create(
				user_id: @subscribed.id,
				trackable_id: @subscription.id,
				trackable_type: "Subscription",
				notification_type: "subscribed_one_time"
			)
		else
			Notification.create(
				user_id: @subscribed.id,
				trackable_id: @subscription.id,
				trackable_type: "Subscription",
				notification_type: "subscribed_recurring"
			)
		end
	end	

	def subscription_update_subscription_record
		@subscription_record = SubscriptionRecord.find_by_subscriber_id_and_subscribed_id(@subscription.subscriber_id,@subscription.subscribed_id)
		if @subscription_record == nil then
			#Create a new subscription record
			@subscription_record = SubscriptionRecord.new(
				subscriber_id: @subscription.subscriber_id,
				subscribed_id: @subscription.subscribed_id,
				past: false
			)
			if @transaction
				@subscription_record.attributes = {
					accumulated_total: @transaction.total,
					accumulated_receive: @transaction.receive,
					accumulated_fee: @transaction.fee,
					counter: @subscription_record.counter+1,
					is_valid: true
				}
				if @subscription.get_reward == 'on'
					@subscription_record.credit += @transaction.total
				end
			end
			@subscription_record.save
		else
			#Update the subscription record
			if @transaction
				@subscription_record.attributes = {
					accumulated_total: @subscription_record.accumulated_total+@transaction.total,
					accumulated_receive: @subscription_record.accumulated_receive+@transaction.receive,
					
				}
				@subscription_record.accumulated_total += @transaction.total
				@subscription_record.accumulated_receive += @transaction.receive
				@subscription_record.accumulated_fee += @transaction.fee	
				@subscription_record.counter = @subscription_record.counter+1
				@subscription_record.is_valid = true
				if @subscription.get_reward == 'on'
					@subscription_record.credit += @transaction.total
				end
			end		
			@subscription_record.save
		end		
		#Subscription 
		if @transaction
			@subscription.accumulated_total += @transaction.total
			@subscription.accumulated_receive += @transaction.receive
			@subscription.accumulated_fee += @transaction.fee		
			@subscription.first_payment = true
			@subscription.first_payment_created_at = Time.now
			@subscription.counter = @subscription.counter+1
		end
		@subscription.subscription_record_id = @subscription_record.id
		@subscription.save
	end

	def subscription_update_billing_subscription
		if @subscriber.billing_subscription == nil then
			#Create a new billing subscription
			@billing_subscription = BillingSubscription.new
			@billing_subscription.user_id = @subscriber.id
			if @transaction
				@billing_subscription.accumulated_total = @transaction.total
				@billing_subscription.accumulated_payment_fee += @transaction.fee
				@billing_subscription.accumulated_receive += @transaction.receive	
			end		
			@billing_subscription.next_billing_date = Time.now.beginning_of_month.next_month + 21.day
			@billing_subscription.next_amount = @subscription.amount
			@billing_subscription.activated = true
			@billing_subscription.activated_at = Time.now
			@billing_subscription.save
		else
			#Update the old billing subscription
			@billing_subscription = @subscriber.billing_subscription
			if @transaction
				@billing_subscription.accumulated_total += @transaction.total
				@billing_subscription.accumulated_payment_fee += @transaction.fee
				@billing_subscription.accumulated_receive += @transaction.receive
			end
			@billing_subscription.next_amount += @subscription.amount
			@billing_subscription.activated = true
			@billing_subscription.activated_at = Time.now			
			@billing_subscription.save
		end
	end

	def subscription_update_billing_artist
		if @subscribed.billing_artist == nil then
			#Create a new billing artist
			@billing_artist = BillingArtist.new
			@billing_artist.user_id = @subscribed.id
			@billing_artist.next_billing_date = Time.now.beginning_of_month.next_month + 27.day
			if @transaction
				@billing_artist.next_amount = @transaction.receive
			end
			@billing_artist.save
		else
			#Update the old billing artist
			@billing_artist = @subscribed.billing_artist
			if @transaction
				@billing_artist.next_amount += @transaction.receive
			end
			@billing_artist.save
		end
	end

	def subscription_add_follower
		if @subscriber != @subscribed
			unless @liked_user = LikedUser.find_by_liked_id_and_liker_id(@subscribed.id, @subscriber.id)
				@liked_user = LikedUser.create(
					liker_id: @subscriber.id,
					liked_id: @subscribed.id
				)
				#if friends make them friends
				if @reverse_liked_user = LikedUser.find_by_liked_id_and_liker_id(@subscriber.id, @subscribed.id)
					@friendship = Friendship.where(user_id: @subscriber.id, friend_id: @subscribed.id).first_or_create(
						user_id: @subscriber.id,
						friend_id: @subscribed.id,
						friendship_init: @subscriber.id
					)
					@reverse_friendship = Friendship.where(user_id: @subscribed.id, friend_id: @subscriber.id).first_or_create(
						user_id: @subscribed.id,
						friend_id: @subscriber.id,
						friendship_init: @subscribed.id
					)
				end
			end
		end
	end

	def subscription_create_or_find_a_transfer
		if @subscribed.transfer != nil then
			@transfer = @subscribed.transfer
			@transfer.user_id = @subscribed.id
			@transfer.billing_artist_id = @billing_artist.id
			@transfer.method = "Stripe"
			@transfer.collected_amount += @subscription.amount
			@transfer.collected_fee += @transaction.fee
			@transfer.collected_receive += @transaction.receive
			@transfer.save
			@transaction.transfer_id = @transfer.id 
			@transaction.save
		else
			@transfer = Transfer.new
			@transfer.user_id = @subscribed.id
			@transfer.billing_artist_id = @billing_artist.id
			@transfer.method = "Stripe"
			@transfer.collected_amount += @subscription.amount
			@transfer.collected_fee += @transaction.fee
			@transfer.collected_receive += @transaction.receive
			@transfer.save
			@transaction.transfer_id = @transfer.id 
			@transaction.save				
		end		
	end

	def unsubscribe(reason_number)
		#update subscription
		@subscription.update(
			deleted_reason: reason_number,
			deleted: true,
			deleted_at: Time.now
		)
		#update subscription_record
		if @subscription_record = SubscriptionRecord.find_by_subscriber_id_and_subscribed_id(@subscription.subscriber_id,@subscription.subscribed_id)
			unless @subscription.funding_type == 'one_time'
				if @subscription_record.duration == nil then
					@subscription_record.duration = @subscription.deleted_at - @subscription.created_at
				else
					duration = @subscription.deleted_at - @subscription.created_at
					@subscription_record.duration = @subscription_record.duration + duration
				end	
				valid_subscription = ((@subscription.deleted_at - @subscription.created_at)/1.day).to_i
				if valid_subscription < 30 then
					PublicActivity::Activity.where(trackable_id: @subscription.id,trackable_type:'Subscription').each do |activity|
						if activity != nil then 
							activity.deleted = true
							activity.deleted_at = Time.now
							activity.save
						end
					end
				end
				if @subscription.reward_receivers
					@subscription.reward_receivers.where(:paid => false, :status => nil, :deleted => nil).each do |reward_receiver|
						reward_receiver.update(
							deleted: true,
							deleted_at: Time.now
						)
					end
				end
			end
			@subscription_record.update(
				past: true
			)
		end
		#clear billing subscription
		if @billing_subscription != nil then
			@billing_subscription.next_amount = @billing_subscription.next_amount - @subscription.amount
			unless @subscriber.subscriptions.any? then
				@billing_subscription.activated = false
			end
			@billing_subscription.save
		end	
		if @billing_artist != nil then
			@billing_artist.next_amount = @billing_artist.next_amount - @subscription.amount
			@billing_artist.save
		end
	end

	def connect_to_stripe
		if Rails.env.production?
			Stripe.api_key = ENV['STRIPE_SECRET_KEY']
		else
			Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
		end
	end	

	def check_if_active_subscription
		if @subscribed.subscribed_by?(@subscriber.id) || @subscriber.subscribed_by?(@subscribed.id)
			flash[:alert] = t('errors.messages.already_backed')
			redirect_to(:back)
		end
	end

end