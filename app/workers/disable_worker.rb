class DisableWorker
	@queue = :disable_queue

	def self.perform(user_id)
		@user = User.find(user_id)

		#User as subscribed begin -------
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
  			when ENV["PRICE_1"].to_f
  				@user.subscription_amount = @user.subscription_amount - ENV["PRICE_1_RECEIVE"].to_f
  			when ENV["PRICE_2"].to_f
  				@user.subscription_amount = @user.subscription_amount - ENV["PRICE_2_RECEIVE"].to_f
  			when ENV["PRICE_3"].to_f
  				@user.subscription_amount = @user.subscription_amount - ENV["PRICE_3_RECEIVE"].to_f
  			when ENV["PRICE_4"].to_f
 	 			@user.subscription_amount = @user.subscription_amount - ENV["PRICE_4_RECEIVE"].to_f
  			when ENV["PRICE_5"].to_f
 	 			@user.subscription_amount = @user.subscription_amount - ENV["PRICE_5_RECEIVE"].to_f
 	 		when ENV["PRICE_6"].to_f
	  			@user.subscription_amount = @user.subscription_amount - ENV["PRICE_6_RECEIVE"].to_f
 	 		end	
 	 		@user.save							
			end
		end		
		#User as subscribed end ------

		#User as subscriber begin -----
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
 	 			when ENV["PRICE_1"].to_f
 	 				subscribed.subscription_amount = subscribed.subscription_amount - ENV["PRICE_1_RECEIVE"].to_f
 	 			when ENV["PRICE_2"].to_f
 	 				subscribed.subscription_amount = subscribed.subscription_amount - ENV["PRICE_2_RECEIVE"].to_f
 	 			when ENV["PRICE_3"].to_f
  					subscribed.subscription_amount = subscribed.subscription_amount - ENV["PRICE_3_RECEIVE"].to_f
 	 			when ENV["PRICE_4"].to_f
 		 			subscribed.subscription_amount = subscribed.subscription_amount - ENV["PRICE_4_RECEIVE"].to_f
  				when ENV["PRICE_5"].to_f
 		 			subscribed.subscription_amount = subscribed.subscription_amount - ENV["PRICE_5_RECEIVE"].to_f
 		 		when ENV["PRICE_6"].to_f
		  			subscribed.subscription_amount = subscribed.subscription_amount - ENV["PRICE_6_RECEIVE"].to_f
 		 		end	
 	 			subscribed.save					
			end
		end				
		#User as subscriber end -----
		
	end


end