module SubscriptionsHelper
	def find_subscription_time(subscriber_id,subscribed_id)
		return Subscription.find_by_subscriber_id_and_subscribed_id(subscriber_id,subscribed_id).created_at
	end

	def find_subscription_amount(subscriber_id,subscribed_id)
		return Subscription.find_by_subscriber_id_and_subscribed_id(subscriber_id,subscribed_id).amount
	end	

	def find_subscription_duration(subscriber_id, subscribed_id)
		subscription_record = SubscriptionRecord.find_by_subscriber_id_and_subscribed_id(subscriber_id, subscribed_id)
		duration = subscription_record.duration

		secs  = duration.to_int
    	mins  = secs / 60
   		hours = mins / 60
    	days  = hours / 24

		if days > 0 then
			return "#{days} days and #{hours % 24} hours"
		else 
			if hours > 0 then
				return "#{hours} hours and #{mins % 60} minutes"
			else
				if mins > 0 then
					return "#{mins} minutes and #{secs % 60} seconds"
				else
					if secs >= 0 then
						return "#{secs} seconds"
					end
				end
			end
		end
	end
end