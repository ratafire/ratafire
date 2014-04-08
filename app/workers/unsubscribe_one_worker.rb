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
				#destroy activities as well if accumulated total is 0
				if subscription.accumulated_total == nil || subscription.accumulated_total == 0 then
					PublicActivity::Activity.find_all_by_trackable_id_and_trackable_type(subscription.id,'Subscription').each do |activity|
						if activity != nil then 
							activity.deleted = true
							activity.deleted_at = Time.now
							activity.save
						end
					end
				end		
				#Add to User's Subscription amount
				subscribed = User.find(subscription.subscribed_id)
				case subscription.amount
  				when 7.71
  					subscribed.subscription_amount = subscribed.subscription_amount - 7.00
  				when 13.16
  					subscribed.subscription_amount = subscribed.subscription_amount - 12.00
  				when 19.24
  					subscribed.subscription_amount = subscribed.subscription_amount - 17.00
  				when 27.03
 	 				subscribed.subscription_amount = subscribed.subscription_amount - 24.00
  				when 57.54
 	 				subscribed.subscription_amount = subscribed.subscription_amount - 50.00
 	 			when 114.78
	  				subscribed.subscription_amount = subscribed.subscription_amount - 100.00
 	 			end	
 	 			subscribed.save								
		end
	end	

end	