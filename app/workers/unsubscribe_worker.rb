class UnsubscribeWorker

	@queue = :unsubscribe_queue

	def self.perform(user_id, reason_number)
		@user = User.find(user_id)
		@subscribed = @user
		if @user.subscriptions.count != 0 then
			@user.subscriptions.each do |s|
				@subscriber = User.find(s.subscriber_id)
				#Mark Subscription Records as having pasts
				subscription_record = SubscriptionRecord.find(s.subscription_record_id)
				subscription_record.past = true
				if subscription_record.duration == nil then
					subscription_record.duration = s.deleted_at - s.created_at
				else
					duration = s.deleted_at - s.created_at
					subscription_record.duration = subscription_record.duration + duration
				end				
				subscription_record.save
				valid_subscription = ((subscription.deleted_at - subscription.created_at)/1.day).to_i
				if subscription.accumulated_total == nil || subscription.accumulated_total == 0 || valid_subscription < 30 then
					PublicActivity::Activity.find_all_by_trackable_id_and_trackable_type(s.id,'Subscription').each do |activity|
						if activity != nil then 
							activity.deleted = true
							activity.deleted_at = Time.now
							activity.save
						end
					end
				end						
			#Add to User's Subscription amount
			case subscription.amount
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


end