class UnsubscribeOneWorker

	@queue = :unsubscribe_one_queue

	def self.perform(subscribed_id, subscriber_id, reason_number)
		subscription = Subscription.find_by_subscribed_id_and_subscriber_id(subscribed_id, subscriber_id)
		if subscription != nil then
				#Cancel Amazon Payments Token
				response = AmazonFlexPay.cancel_token(subscription.amazon_recurring.tokenID)
				subscription.deleted_reason = reason_number
				subscription.deleted = true
				subscription.deleted_at = Time.now
				subscription.next_transaction_queued = false
				subscription.save
				#Mark Subscription Records as having pasts
				subscription_record = SubscriptionRecord.find(subscription.subscription_record_id)
				subscription_record.past = true
				if subscription_record.duration == nil then
					subscription_record.duration = subscription.deleted_at - subscription.created_at
				else
					duration = subscription.deleted_at - subscription.created_at
					subscription_record.duration = subscription_record.duration + duration
				end				
				subscription_record.save
				valid_subscription = ((subscription.deleted_at - subscription.created_at)/1.day).to_i
				if subscription.accumulated_total == nil || subscription.accumulated_total == 0 || valid_subscription < 30 then
					PublicActivity::Activity.find_all_by_trackable_id_and_trackable_type(subscription.id,'Subscription').each do |activity|
						if activity != nil then 
							activity.deleted = true
							activity.deleted_at = Time.now
							activity.save
						end
					end
				end		
				#Remove Enqueued Transaction
				Resque.remove_delayed(SubscriptionNowWorker, subscription.uuid)				
				#Add to User's Subscription amount
				@subscribed = User.find(subscription.subscribed_id)
				@subscriber = User.find(subscription.subscriber_id)
				case subscription.amount
  			when ENV["PRICE_0"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_0_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_0"].to_f					
  			when ENV["PRICE_1"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_1_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_1"].to_f
  			when ENV["PRICE_2"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_2_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_2"].to_f
  			when ENV["PRICE_3"].to_f
  				@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_3_RECEIVE"].to_f
  				@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_3"].to_f
  			when ENV["PRICE_4"].to_f
 	 			@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_4_RECEIVE"].to_f
 	 			@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_4"].to_f
  			when ENV["PRICE_5"].to_f
 	 			@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_5_RECEIVE"].to_f
 	 			@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_5"].to_f
 	 		when ENV["PRICE_6"].to_f
	  			@subscribed.subscription_amount = @subscribed.subscription_amount - ENV["PRICE_6_RECEIVE"].to_f
	  			@subscriber.subscribing_amount = @subscriber.subscribing_amount - ENV["PRICE_6"].to_f
 	 		end	
 	 		@subscribed.save
 	 		@subscriber.save							
		end
	end	

end	