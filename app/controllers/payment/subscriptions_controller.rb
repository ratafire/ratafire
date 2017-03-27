class Payment::SubscriptionsController < ApplicationController

	before_filter :load_subscriber, only:[:create, :unsub]
	before_filter :load_reverse_subscriber, only:[:destroy]
	before_filter :check_if_active_subscription, only: [:create]
	before_filter :check_if_spam, only: [:create]
	before_filter :check_if_all_gone, only: [:create]
	before_filter :check_if_reward_receiver, only: [:create]
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
		if params[:subscription][:majorpost_id]
			@subscription.majorpost_id = params[:subscription][:majorpost_id]
		end
		if params[:subscription][:upper_limit]
			@subscription.upper_limit = params[:subscription][:upper_limit]
		end
		if params[:subscription][:cards_attributes]
			add_card
		end
		#Charge if charge
		if @subscription.funding_type == 'one_time'
			#Charge the card now
			subscribe_through_stripe
		else
			#Do not charge the card
			subscription_post_payment
		end
	rescue Stripe::CardError => e
		# Since it's a decline, Stripe::CardError will be caught
		body = e.json_body
		err  = body[:error]

		puts "Status is: #{e.http_status}"
		puts "Type is: #{err[:type]}"
		puts "Code is: #{err[:code]}"
		# param is '' in this case
		puts "Param is: #{err[:param]}"
		puts "Message is: #{err[:message]}"
		#Show to the user
		flash[:error] = "#{err[:message]}"
		redirect_to how_i_pay_user_studio_wallets_path(@subscriber.username)
	rescue Stripe::RateLimitError => e
		# Too many requests made to the API too quickly
		flash[:error] = t('errors.messages.too_many_requests')
		redirect_to profile_url_path(@subscribed.username)
	rescue Stripe::InvalidRequestError => e
		# Invalid parameters were supplied to Stripe's API
		flash[:error] = t('errors.messages.not_saved')
		redirect_to profile_url_path(@subscribed.username)
	rescue Stripe::AuthenticationError => e
		# Authentication with Stripe's API failed
		# (maybe you changed API keys recently)
		flash[:error] = t('errors.messages.not_saved')
		redirect_to profile_url_path(@subscribed.username)
	rescue Stripe::APIConnectionError => e
		# Network communication with Stripe failed
		flash[:error] = t('errors.messages.not_saved')
		redirect_to profile_url_path(@subscribed.username)
	rescue Stripe::StripeError => e
		# Display a very generic error to the user, and maybe send
		# yourself an email
		flash[:error] = t('errors.messages.not_saved')
		redirect_to profile_url_path(@subscribed.username)
	rescue 
		# General rescue
		flash[:error] = t('errors.messages.not_saved')
		redirect_to profile_url_path(@subscribed.username)
	end

	# user_payment_subscriptions DELETE
	# /users/:user_id/payment/subscriptions
	# user is the subscriber
	# current_user is the subscribed
	def destroy
		Subscription.unsubscribe(reason_number: 2, subscriber_id:@subscriber.id, subscribed_id: @subscribed.id)
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
		Subscription.unsubscribe(reason_number: 1, subscriber_id:@subscriber.id, subscribed_id: @subscribed.id)
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
			if @subscriber.card
				#retrieve old and new stripe 
				@new_card = @customer.sources.retrieve(@card.card_stripe_id)
				#Make new as default
				@customer.default_source = @new_card.id
				@customer.save
				#delete old
				if @old_card = @customer.sources.retrieve(@subscriber.card.card_stripe_id)
					@old_card.delete
				end
				@subscriber.card.destroy
			end
			@card.user_id = @subscriber.id
			@card.save
		else
			redirect_to(:back)
		end
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
		#Calculate application fee
		@application_fee = ((@subscription.amount*0.029+0.3+(@subscription.amount-(@subscription.amount*0.029+0.3))*0.0005)*100).to_i+1
		#Charge
		if @subscriber.customer
			response = Stripe::Charge.create(
				:amount => @subscription.amount.to_i*100,
				:currency => "usd",
				:customer => @subscriber.customer.customer_id,
				:description => t('views.payment.backs.ratafire_payment'),
				:destination => @subscribed.stripe_account.stripe_id,
				:application_fee => @application_fee
			)
		else
			response = Stripe::Charge.create(
				:amount => @subscription.amount.to_i*100,
				:currency => "usd",
				:customer => @customer.id,
				:description => t('views.payment.backs.ratafire_payment'),
				:destination => @subscribed.stripe_account.stripe_id,
				:application_fee => @application_fee
			)			
		end
		if response.try(:captured) == true && response.try(:status) == "succeeded"
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
			:transaction_type => 'Back',
			:transaction_method => "Stripe",
			:currency => "usd"
			)
			#Create transaction detail
			@transaction_subset = TransactionSubset.create(
				campaign_id: @subscribed.try(:active_campaign).try(:id),
				transaction_id: @transaction.id,
				user_id: @subscriber.id,
				subscriber_id: @subscriber.id,
				subscribed_id: @subscribed.id,
				updates: 0,
				currency: 'usd',
				amount: @subscription.amount,
				description: t('mailer.payment.subscription.receipt.support') + @subscription.subscribed.preferred_name
			)
			subscription_post_payment
		else
			flash[:error] = t('views.creator_studio.how_i_pay.card_info') + t('errors.messages.invalid')
			#redirect_to how_i_get_paid_user_studio_wallets_path(@subscriber.username)
			redirect_to how_i_pay_user_studio_wallets_path(@subscriber.username)
		end
	end

	def subscription_post_payment
		if @subscription.save
			#Add shipping address
			if params[:subscription][:shipping_addresses_attributes]
				add_shipping_address
			end
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
			#Update campaign
			subscription_update_active_campaign
			#Update Majorpost
			subscription_update_active_majorpost
			#Update billing artist
			subscription_update_billing_artist
			#Make a follower
			subscription_add_follower
			#Update reward
			subscription_update_active_reward
			#Post to streamlabs
			post_to_streamlabs
			#Achievement
			create_achievement
			#Create receiver
			if @subscription.get_reward == 'on'
				#Create reward receiver
				subscription_create_receiver
			end
			#Unsubscribe the one time backer
			if @subscription.funding_type == 'one_time'
				Subscription.unsubscribe(reason_number:8, subscriber_id:@subscriber.id, subscribed_id: @subscribed_id)
				if @transaction
				end
				#Add score
				add_score(@subscribed, @subscriber)
			else
				#update billing_subscription
				subscription_update_billing_subscription				
				@subscription.update(
					activated: true
				)
			end
			redirect_to profile_url_path(@subscribed.username)
		else
			flash['error'] = @subscription.errors.full_messages
			redirect_to(:back)
		end
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
		if @subscribed.active_reward.shipping == 'no'
			create_reward_receiver
		else
			if @shipping_address
				create_reward_receiver_with_shipping
			else
				if @shipping_address = ShippingAddress.find_by_user_id_and_country(@subscriber.id, params[:subscription][:shipping_country])
					create_reward_receiver_with_shipping
				else
					flash[:error] = t('errors.messages.not_saved')
					redirect_to(:back)
				end
			end
		end
	end

	def create_reward_receiver_with_shipping
		if @reward_receiver = RewardReceiver.find_by_reward_id_and_user_id(@subscribed.active_reward.id, @subscriber.id)
			unless @reward_receiver.paid
				if @transaction
					@reward_receiver.update(
						paid: true,
						status: 'paid'
					)
					@subscription_record.credit -= @subscribed.active_reward.amount
					@subscription_record.save
				end
			end
		else
			unless @shipping_address
				@shipping_address = @subscriber.shipping_address
			end
			#Select shipping amount based on different situiations
			if @subscribed.active_reward.shippings.where(country: @shipping_address.country).first
				shipping_amount = @subscribed.active_reward.shippings.where(country: @shipping_address.country).first.amount
			else
				if @subscribed.active_reward.shipping_anywhere
					shipping_amount = @subscribed.active_reward.shipping_anywhere.amount
				else
					shipping_amount = 0
				end
			end
			if @reward_receiver = RewardReceiver.create(
				amount: shipping_amount,
				user_id: @subscriber.id,
				reward_id: @subscribed.active_reward.id,
				subscription_id: @subscription.id,
				campaign_id: @subscribed.active_campaign.id,
				shipping_address_id: @shipping_address.id,
				status: 'waiting_for_payment'
			)
				if @transaction
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
		end
	end

	def create_reward_receiver
		if @reward_receiver = RewardReceiver.find_by_reward_id_and_user_id(@subscribed.active_reward.id, @subscriber.id)
			unless @reward_receiver.paid
				if @transaction
					@reward_receiver.update(
						paid: true,
						status: 'paid'
					)
					@subscription_record.credit -= @subscribed.active_reward.amount
					@subscription_record.save
				end
			end
		else
			if @reward_receiver = RewardReceiver.create(
				user_id: @subscriber.id,
				reward_id: @subscribed.active_reward.id,
				subscription_id: @subscription.id,
				campaign_id: @subscribed.active_campaign.id,
				status: 'waiting_for_payment'				
			)
				if @transaction
					@reward_receiver.update(
						paid: true,
						status: 'paid'
					)
					@subscription_record.credit -= @subscribed.active_reward.amount
					@subscription_record.save
				end
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
					accumulated_fee: @subscription_record.accumulated_fee+@transaction.fee,
					counter: @subscription_record.counter+1,
					is_valid: true
				}
				if @subscription.get_reward == 'on'
					@subscription_record.credit += @transaction.total
				end
			end		
			@subscription_record.save
		end		
		#Subscription 
		if @transaction
			@subscription.attributes = {
				accumulated_total: @subscription.accumulated_total+@transaction.total,
				accumulated_receive: @subscription.accumulated_receive+@transaction.receive,
				accumulated_fee: @subscription.accumulated_fee+@transaction.fee,
				first_payment: true,
				first_payment_created_at: Time.now,
				counter: @subscription.counter+1
			}
		end
		@subscription.subscription_record_id = @subscription_record.id
		@subscription.save
	end

	def subscription_update_active_campaign
		if @campaign = Campaign.find(@subscription.campaign_id)
			if @transaction
				@campaign.update(
					accumulated_total: @campaign.accumulated_total+@transaction.total,
					accumulated_receive: @campaign.accumulated_total+@transaction.receive,
					accumulated_fee: @campaign.accumulated_fee+@transaction.fee,
					predicted_total: @campaign.predicted_total+@subscription.amount,
					predicted_receive: @campaign.predicted_receive+@transaction.fee,
					predicted_fee: @campaign.predicted_fee+@transaction.receive
				)
			else
				@campaign.update(
					predicted_total: @campaign.predicted_total+@subscription.amount,
					recurring_total: @campaign.recurring_total+@subscription.amount
				)
			end
		end
	end

	def subscription_update_active_majorpost
		if params[:subscription][:majorpost_id] && @majorpost = Majorpost.find(@subscription.majorpost_id)
			if @transaction
				@majorpost.update(
					accumulated_total: @majorpost.accumulated_total+@transaction.total,
					accumulated_receive: @majorpost.accumulated_total+@transaction.receive,
					accumulated_fee: @majorpost.accumulated_fee+@transaction.fee,
					predicted_total: @majorpost.predicted_total+@subscription.amount,
					predicted_receive: @majorpost.predicted_receive+@transaction.fee,
					predicted_fee: @majorpost.predicted_fee+@transaction.receive
				)
			else
				#Update latest paid update
				if @majorpost 
					@majorpost.update(
						predicted_total: @majorpost.predicted_total+@subscription.amount,
						recurring_total: @majorpost.recurring_total+@subscription.amount
					)
				end
			end
		end
	end

	def subscription_update_active_reward
		if @reward = @subscribed.active_reward
			if @transaction
				#Update rewards
				@reward.update(
					accumulated_total: @reward.accumulated_total+@subscription.amount,
					accumulated_receive: @reward.accumulated_receive+@transaction.fee,
					accumulated_fee: @reward.accumulated_fee+@transaction.receive,
					predicted_total: @reward.predicted_total+@subscription.amount,
					predicted_receive: @reward.predicted_receive+@transaction.fee,
					predicted_fee: @reward.predicted_fee+@transaction.receive
				)
			else
				@reward.update(
					predicted_total: @reward.predicted_total+@subscription.amount,
					recurring_total: @reward.recurring_total+@subscription.amount
				)
			end
		end
	end

	def post_to_streamlabs
		if @subscribed.streamlab
			if @transaction
				#one time
				@subscribed.streamlab.post_alert(
					transaction_id: @transaction.id, 
					amount: @subscription.amount.to_i, 
					currency: @subscription.currency, 
					subscriber_id: @subscriber.id,
					email: @subscriber.email,
					name: @subscriber.preferred_name,
					alert_type: 'donation'
				)
			else
				#subscription
				if @subscription.campaign_funding_type == 'creation'
					#per creation
					@subscribed.streamlab.post_alert(
						amount: @subscription.amount.to_i, 
						currency: @subscription.currency, 
						subscriber_id: @subscriber.id,
						subscription_type: 'per_creation',
						name: @subscriber.preferred_name,
						alert_type: 'subscription'
					)
				else
					#per month
					@subscribed.streamlab.post_alert(
						amount: @subscription.amount.to_i, 
						currency: @subscription.currency, 
						subscriber_id: @subscriber.id,
						subscription_type: 'per_month',
						name: @subscriber.preferred_name,
						alert_type: 'subscription'
					)
				end
			end
		end
	end

	def create_achievement
		if @subscription_record.try(:is_valid)
			Resque.enqueue(Achievement::SubscriptionsCreate, @subscription.id)
		end
	end

	def subscription_update_billing_subscription
		if @subscriber.billing_subscription == nil then
			#Create a new billing subscription
			@billing_subscription = BillingSubscription.new(
				user_id: @subscriber.id,
				next_billing_date: Time.now.beginning_of_month.next_month + 21.day,
				next_amount: @subscription.amount,
				activated: true,
				activated_at: Time.now
			)
			if @transaction
				@billing_subscription.attributes = {
					accumulated_total: @transaction.total,
					accumulated_payment_fee: @billing_subscription.accumulated_payment_fee+@transaction.fee,
					accumulated_receive: @billing_subscription.accumulated_receive+@transaction.receive
				}
			end	
			@billing_subscription.save
		else
			#Update the old billing subscription
			@billing_subscription = @subscriber.billing_subscription
			if @transaction
				@billing_subscription.attributes = {
					accumulated_total: @billing_subscription.accumulated_total+@transaction.total,
					accumulated_payment_fee: @billing_subscription.accumulated_payment_fee+@transaction.fee,
					accumulated_receive: @billing_subscription.accumulated_receive+@transaction.receive
				}
			end
			@billing_subscription.attributes = {
				next_amount: @billing_subscription.next_amount+@subscription.amount,
				activated: true,
				activated_at: Time.now
			}	
			@billing_subscription.save
		end
	end

	def subscription_update_billing_artist
		if @subscribed.billing_artist == nil then
			#Create a new billing artist
			@billing_artist = BillingArtist.new(
				user_id: @subscribed.id,
				next_billing_date: Time.now.beginning_of_month.next_month + 27.day,
				predicted_next_amount: @subscription.amount
			)
			if @transaction
				@billing_artist.next_amount = @transaction.receive
			end
			@billing_artist.save
		else
			#Update the old billing artist
			@billing_artist = @subscribed.billing_artist
			@billing_artist.predicted_next_amount += @subscription.amount
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

	def check_if_all_gone
		if params[:subscription][:get_reward] == 'on'
			if @subscribed.active_reward.backers > 0 && @subscribed.active_reward.reward_receivers.count >= @subscribed.active_reward.backers
				flash[:alert] = t('errors.messages.all_gone')
				redirect_to new_user_payment_backs_path(@subscribed.uid)
			end
		end
	end

	def check_if_reward_receiver
		if params[:subscription][:get_reward] == 'on'
			if @subscribed.active_reward.try(:reward_receivers).where(:user_id => @subscriber.id).count > 0
				flash[:alert] = t('errors.messages.had_it')
				redirect_to new_user_payment_backs_path(@subscribed.uid)
			end
		end
	end

	def check_if_spam
		if Rails.env.production?
			#One time funding
			if params[:subscription][:funding_type] == 'one_time'
				if @one_time_history = Subscription.where(funding_type: 'one_time', subscribed_id: @subscribed.id, subscriber_id: @subscriber.id).try(:first)
					@days = ((Time.now - @one_time_history.created_at)/1.day).round
					if @days <= 3 then
						@indays = 3-@days
						flash[:alert] = t('errors.messages.wait_3_days')
						redirect_to profile_url_path(@subscribed.username)
					end
				end
			end
			#Recurring
			if params[:subscription][:funding_type] == 'recurring'
				if @recurring_history = Subscription.where(funding_type: 'recurring', real_deleted: true, subscribed_id: @subscribed.id, subscriber_id: @subscriber.id).try(:first)
					@days = ((Time.now - @recurring_history.deleted_at)/1.day).round
					if @days <= 15 then
						@indays = 15-@days
						flash[:alert] = t('errors.messages.wait_15_days')
						redirect_to profile_url_path(@subscribed.username)
					end
				end
			end	
		end	
	end

	def add_score(subscribed, subscriber)
		#Add score to subscriber
		if subscriber.try(:level) <= 59
			if @level_xp_subscriber = LevelXp.find(subscriber.level)
				subscriber.add_points(@level_xp_subscriber.get_backer, category: 'subscriber')
			end
			#Check level
			i = subscriber.level
			while subscriber.points >= LevelXp.find(i).total_xp_required
				i += 1
				subscriber_real_level = i
			end
			if subscriber_real_level
				if subscriber_real_level > subscriber.level
					subscriber.update(
						level: subscriber_real_level
					)
                    Notification.create(
                        user_id: subscriber.id,
                        trackable_id: subscriber.level,
                        trackable_type: "Level",
                        notification_type: "level_up"
                    )
                    @levelup_subscriber = true
                    #Check level up achievement
                    Resque.enqueue(Achievement::Level, subscriber.id)
				end
			end
		end
		#Add score to subscribed
		if subscribed.try(:level) <= 59
			if @level_xp_subscribed = LevelXp.find(subscribed.level)
				subscribed.add_points(@level_xp_subscribed.get_backer, category: 'subscribed')
			end
			#Check level
			i = subscribed.level
			while subscribed.points >= LevelXp.find(i).total_xp_required
				i += 1
				subscribed_real_level = i
			end
			if subscribed_real_level
				if subscribed_real_level > subscribed.level 
					subscribed.update(
						level: subscribed_real_level
					)
                    Notification.create(
                        user_id: subscribed.id,
                        trackable_id: subscribed.level,
                        trackable_type: "Level",
                        notification_type: "level_up"
                    )
                    #Check level up achievement
                    Resque.enqueue(Achievement::Level, subscribed.id)
				end
			end
		end
	end

end