class DisableWorker
	@queue = :disable_queue

	def self.perform(user_id)
		@user = User.find(user_id)
		#User as subscribed
		self.user_as_subscribed
		#User as subscriber
		self.user_as_subscriber
		
	end

private
	
	#User as subscribed
	def self.user_as_subscribed
		if @user.subscriptions.count != 0 then
			@user.subscriptions.each do |s|
				#Cancel Amazon Payments Token
				response = AmazonFlexPay.cancel_token(s.amazon_recurring.tokenID)
				s.deleted_reason = reason_number
				s.deleted = true
				s.deleted_at = Time.now
				s.save
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
				#destroy activities as well if accumulated total is 0
				if s.accumulated_total == nil || s.accumulated_total == 0 then
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
  			when 7.71
  				@user.subscription_amount = @user.subscription_amount - 7.00
  			when 13.16
  				@user.subscription_amount = @user.subscription_amount - 12.00
  			when 19.24
  				@user.subscription_amount = @user.subscription_amount - 17.00
  			when 27.03
 	 			@user.subscription_amount = @user.subscription_amount - 24.00
  			when 57.54
 	 			@user.subscription_amount = @user.subscription_amount - 50.00
 	 		when 114.78
	  			@user.subscription_amount = @user.subscription_amount - 100.00
 	 		end	
 	 		@user.save							
			end
		end		
	end


	#User as subscriber
	def self.user_as_subscriber
		if @user.reverse_subscriptions.count != 0 then
			@user.reverse_subscriptions.each do |s|
				#Cancel Amazon Payments Token
				response = AmazonFlexPay.cancel_token(s.amazon_recurring.tokenID)
				s.deleted_reason = reason_number
				s.deleted = true
				s.deleted_at = Time.now
				s.save
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
				#destroy activities as well if accumulated total is 0
				if s.accumulated_total == nil || s.accumulated_total == 0 then
					PublicActivity::Activity.find_all_by_trackable_id_and_trackable_type(s.id,'Subscription').each do |activity|
						if activity != nil then 
							activity.deleted = true
							activity.deleted_at = Time.now
							activity.save
						end
					end
				end
				#Add to User's Subscription amount
				subscribed = User.find(s.subscribed_id)
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

end