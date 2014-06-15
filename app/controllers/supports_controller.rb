class SupportsController < ApplicationController
	layout 'application'

	def supporters
		@user = User.find(params[:id])
		@supporters = @user.supporters.paginate(page: params[:supporters], :per_page => 75)
	end

	def supporting
		@user = User.find(params[:id])
		@supporting = @user.supported.paginate(page: params[:supporting], :per_page => 75)
	end

	def destroy
		@subscription = Subscription.find_by_subscriber_id_and_subscribed_id(params[:subscriber_id],params[:id])
		@user = User.find(@subscription.subscriber_id)
		@subscriber = @user
		#Cancel Amazon Payments Token
		response = AmazonFlexPay.cancel_token(@subscription.amazon_recurring.tokenID)		
		@subscription.deleted_reason = 8
		@subscription.deleted_at = Time.now
		@subscription.save
		#Mark Subscription Records as having pasts
		@subscription_record = SubscriptionRecord.find(@subscription.subscription_record_id)
		@subscription_record.past_support = true	
		if @subscription_record.duration_support == nil then
			@subscription_record.duration_support = @subscription.deleted_at - @subscription.created_at
		else
			duration = @subscription.deleted_at - @subscription.created_at
			@subscription_record.duration_support = @subscription_record.duration + duration
		end	
		@subscription_record.save
		#Add to User's Subscription amount
		@subscribed = User.find(@subscription.subscribed_id)
  		@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_1_RECEIVE"].to_f
  		@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_1"].to_f	
  		@subscriber.supporter_slot += 1
  	 	@subscribed.save
 	 	@subscriber.save	
 	 	flash[:success] = "You removed "+@user.fullname+"!"
 	 	redirect_to(:back) 					
	end

	def unsub
		@subscription = Subscription.find_by_subscriber_id_and_subscribed_id(params[:id],params[:subscribed_id])
		@user = User.find(@subscription.subscribed_id)
		@subscribed = @user
		@subscriber = User.find(@subscription.subscriber_id)
		#Cancel Amazon Payments Token
		response = AmazonFlexPay.cancel_token(@subscription.amazon_recurring.tokenID)
		@subscription.deleted_reason = 9
		@subscription.deleted = true
		@subscription.deleted_at = Time.now
		@subscription.save
		#Mark Subscription Records as having pasts
		@subscription_record = SubscriptionRecord.find(@subscription.subscription_record_id)
		@subscription_record.past_support = true	
		if @subscription_record.duration_support == nil then
			@subscription_record.duration_support = @subscription.deleted_at - @subscription.created_at
		else
			duration = @subscription.deleted_at - @subscription.created_at
			@subscription_record.duration_support = @subscription_record.duration + duration
		end	
		@subscription_record.save
		#Change User's subscription amount
		@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_1_RECEIVE"].to_f
		@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_1"].to_f
		@subscriber.supporter_slot += 1
		@subscribed.save
		@subscriber.save	
		flash[:success] = "You unsupported "+@user.fullname+"!"
		redirect_to(:back)
	end	

end