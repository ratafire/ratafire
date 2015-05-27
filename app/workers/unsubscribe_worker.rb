class UnsubscribeWorker

	@queue = :unsubscribe_queue

	def self.perform(user_id, reason_number)
		@subscriber = User.find(user_id)
		if @subscriber.subscriptionsubscription.count != 0 then
			@subscriber.subscriptionsubscription.each do |subscription|
				@subscribed = User.find(subscription.subscribed_id)
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
				#Add to User's Subscription amount
				@subscribed.subscription_amount = @subscribed.subscription_amount - subscription.amount
				@subscriber.subscribing_amount = @subscriber.subscribing_amount - subscription.amount	
	 	 		@subscribed.save
	 	 		@subscriber.save		
	 	 		#clear billing subscription
				@billing_subscription = BillingSubscription.find_by_user_id(@subscriber.id)
				if @billing_subscription != nil then
					@billing_subscription.next_amount = @billing_subscription.next_amount - subscription.amount
					unless @subscriber.subscriptions.any? then
						@billing_subscription.activated = false
					end
					@billing_subscription.save
				end	
				@billing_artist =  BillingArtist.find_by_user_id(@subscribed.id)	
				if @billing_artist != nil then
					@billing_artist.next_amount = @billing_artist.next_amount - subscription.amount
					@billing_artist.save
				end
			end
		end				
	end


end