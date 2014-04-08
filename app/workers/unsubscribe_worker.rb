class UnsubscribeWorker

	@queue = :unsubscribe_queue

	def self.perform(user_id, reason_number)
		@user = User.find(user_id)
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
				if subscription_record.accumulated_total == nil ||subscription_record.accumulated_total == 0 then
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


end