class DisableWorker
	@queue = :disable_queue

	def perform(user_id)
		@user = User.find(user_id)
		#User as subscribed
		user_as_subscribed
		#User as subscriber
		user_as_subscriber
		
	end

private
	
	#User as subscribed
	def user_as_subscribed
		if @user.subscriptions.count != 0 then
			@user.subscriptions.each do |s|
				@history = SubscriptionHistory.new
				@history.subscriber_id = s.subscriber_id
				@history.subscribed_id = s.subscribed_id
				@history.amount = s.amount
				@history.created_at = s.created_at
				@history.reason = 5
				@history.ended_at = Time.now
				@history.amazon_valid = s.amazon_valid
				@history.accumulated_receive = s.accumulated_receive
				@history.accumulated_amazon = s.accumulated_amazon
				@history.accumulated_total = s.accumulated_total
				@history.subscription_record_id = s.subscription_record_id
				@history.project_id = s.project_id
				@history.save		
				#destroy activities as well if accumulated total is 0
				if s.accumulated_total == nil || s.accumulated_total == 0 then
					PublicActivity::Activity.find_all_by_trackable_id_and_trackable_type(@subscription.id,'Subscription').each do |activity|
						if activity != nil then 
							activity.destroy
						end
					end
				end		
				s.destroy 
			end
		end		
	end


	#User as subscriber
	def user_as_subscriber
		if @user.reverse_subscriptions.count != 0 then
			@user.reverse_subscriptions.each do |s|
				@history = SubscriptionHistory.new
				@history.subscriber_id = s.subscriber_id
				@history.subscribed_id = s.subscribed_id
				@history.amount = s.amount
				@history.created_at = s.created_at
				@history.reason = 6
				@history.ended_at = Time.now
				@history.amazon_valid = s.amazon_valid
				@history.accumulated_receive = s.accumulated_receive
				@history.accumulated_amazon = s.accumulated_amazon
				@history.accumulated_total = s.accumulated_total
				@history.subscription_record_id = s.subscription_record_id
				@history.project_id = s.project_id
				@history.save		
				#destroy activities as well if accumulated total is 0
				if s.accumulated_total == nil || s.accumulated_total == 0 then
					PublicActivity::Activity.find_all_by_trackable_id_and_trackable_type(@subscription.id,'Subscription').each do |activity|
						if activity != nil then 
							activity.destroy
						end
					end
				end		
				s.destroy 
			end
		end		
	end

end