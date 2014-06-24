class AmazonController < ApplicationController

	def pre_create_recipient
		@user = User.find(params[:id])
		user_id = @user.id
		#Destroy existed recipients
		if @user.amazon_recipient != nil then
			@user.amazon_recipient.destroy
		end
		@amazon_recipient = AmazonRecipient.prefill!(:user_id => user_id)
		#Create a recipient pipeline with Amazon
		port = Rails.env.production? ? "" : ":3000"
		callback_url = "#{request.scheme}://#{request.host}#{port}/r/subscriptions/amazon_payments/recipient/postfill"
		redirect_to AmazonFlexPay.recipient_pipeline(@amazon_recipient.uuid, callback_url,
			:recipient_pays_fee => true, :max_variable_fee => 9 )
	end

	def post_create_recipient
		unless params[:callerReference] == nil then
			@amazon_recipient = AmazonRecipient.postfill!(params)
		end
		if params['status'] == 'SR' then
			@user = User.find(@amazon_recipient.user_id)
			@user.amazon_authorized = true
			@user.save	
		end
		if @amazon_recipient != nil then
			if @amazon_recipient.tokenID == nil then 
				@amazon_recipient.destroy
			end
		end
		redirect_to subscription_settings_path(current_user)
	end
	# SR Success. 		Specifies that the merchant's token was created. 
	# A 				Specifies that the pipeline has been aborted by the user. 
	# CE 				Specifies a caller exception.
	# NP				The recipient account is a personal account, and therefore cannot accept credit card payments
	# NM				You are not registered as a third-party caller to make this transaction. Contact Amazon Payments for more information.

	def cancel_recipient
		@user = User.find(params[:id])
		@amazon_recipient = AmazonRecipient.find_by_user_id(@user.id)
		if @amazon_recipient != nil then
			@amazon_recipient.destroy
			@user = User.find(params[:id])
			@user.amazon_authorized = false
			@user.save
			#Unsubscribe the subscribers of the user
			Resque.enqueue(UnsubscribeWorker, @user.id, 7)
			flash[:success] = "You are disconnected from Amazon Payments."
		end
		redirect_to(:back)
	end

	def reconnect_recipient
		@user = User.find(params[:id])
		user_id = @user.id
		@amazon_recipient = @user.amazon_recipient
		if @amazon_recipient != nil then
			port = Rails.env.production? ? "" : ":3000"
			callback_url = "#{request.scheme}://#{request.host}#{port}/r/subscriptions/amazon_payments/recipient/postfill"
			response = AmazonFlexPay.get_recipient_verification_status(@amazon_recipient.tokenID)
			if response.recipient_verification_status == "Active" then
				@amazon_recipient.Status = "SR"
				@amazon_recipient.save
				@user.amazon_authorized = true
				@user.save
				flash[:success] = "You are connected to Amazon Payments!"
			end
		end
		redirect_to subscription_settings_path(current_user)
	end

	def post_subscribe
		unless params[:callerReference].blank?
			@subscription = Subscription.find_by_uuid(params[:callerReference])
			@amazon_recurring = AmazonRecurring.postfill!(params)
		end
		#Add activity to the subscribed
		#SA 		Success status for the ABT payment method
		#SB 		Success status for the ACH (bank account) payment method
		#SC 		Success status for the credit card payment method
		if params['status'] == 'SA' || params['status'] == 'SB' || params['status'] == 'SC' then
			if @subscription.supporter_switch == true
				#Create Support
				support_register
				Resque.enqueue(SubscriptionNowWorker,params[:callerReference])
			else
				#Create Subscription
				subscription_register
				Resque.enqueue(SubscriptionNowWorker,params[:callerReference])
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
		end

		if @subscription.supporter_switch == true
			redirect_to supporters_path(@subscription.subscribed_id)
		else
			redirect_to subscribers_path(@subscription.subscribed_id)
		end
	end

private

	def subscription_register

			@subscription.activated = true
			@subscription.activated_at = Time.now
			#Create activity
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

			#Create Subscription Record
			@subscription_record = SubscriptionRecord.find_by_subscriber_id_and_subscribed_id(@subscription.subscriber_id,@subscription.subscribed_id)
			if @subscription_record == nil then
				@subscription_record = SubscriptionRecord.new
				@subscription_record.subscriber_id = @subscription.subscriber_id
				@subscription_record.subscribed_id = @subscription.subscribed_id
				@subscription_record.supporter_switch = @subscription.supporter_switch
				@subscription_record.save
			end

			#Add to User's Subscription amount
			@subscribed = User.find(@subscription.subscribed_id)
			@subscriber = User.find(@subscription.subscriber_id)
			case @subscription.amount
  			when ENV["PRICE_1"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount + ENV["PRICE_1_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount + ENV["PRICE_1"].to_f
  			when ENV["PRICE_2"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount + ENV["PRICE_2_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount + ENV["PRICE_2"].to_f
  			when ENV["PRICE_3"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount + ENV["PRICE_3_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount + ENV["PRICE_3"].to_f
  			when ENV["PRICE_4"].to_f
 	 			@subscribed.subscription_amount = @subscribed.subscription_amount + ENV["PRICE_4_RECEIVE"].to_f
 	 			@subscriber.subscribing_amount = @subscriber.subscribing_amount + ENV["PRICE_4"].to_f
  			when ENV["PRICE_5"].to_f
 	 			@subscribed.subscription_amount = @subscribed.subscription_amount + ENV["PRICE_5_RECEIVE"].to_f
 	 			@subscriber.subscribing_amount = @subscriber.subscribing_amount + ENV["PRICE_5"].to_f
 	 		when ENV["PRICE_6"].to_f
	  			@subscribed.subscription_amount = @subscribed.subscription_amount + ENV["PRICE_6_RECEIVE"].to_f
	  			@subscriber.subscribing_amount = @subscriber.subscribing_amount + ENV["PRICE_6"].to_f
 	 		end
 	 		@subscribed.save
 	 		@subscriber.save
 	 		
			@subscription.subscription_record_id = @subscription_record.id
			@subscription.save		
			flash[:success] = "You subscribed to "+@subscription.subscribed.fullname+"!"
	end

	def support_register
			@subscription.activated = true
			@subscription.activated_at = Time.now

			#Create Subscription Record
			@subscription_record = SubscriptionRecord.find_by_subscriber_id_and_subscribed_id(@subscription.subscriber_id,@subscription.subscribed_id)
			if @subscription_record == nil then
				@subscription_record = SubscriptionRecord.new
				@subscription_record.subscriber_id = @subscription.subscriber_id
				@subscription_record.subscribed_id = @subscription.subscribed_id
				@subscription_record.supporter_switch = @subscription.supporter_switch
				@subscription_record.save
			end

			#Add to User's Subscription amount
			@subscribed = User.find(@subscription.subscribed_id)
			@subscriber = User.find(@subscription.subscriber_id)

  			@subscribed.subscription_amount = @subscribed.subscription_amount + ENV["PRICE_1_RECEIVE"].to_f
  			@subscriber.subscribing_amount = @subscriber.subscribing_amount + ENV["PRICE_1"].to_f

  			@subscriber.supporter_slot -= 1

 	 		@subscribed.save
 	 		@subscriber.save
 	 		
			@subscription.subscription_record_id = @subscription_record.id
			@subscription.save				
		
			flash[:success] = "You became a supporter of "+@subscription.subscribed.fullname+"!"
	end

end