class SubscriptionTimebombWorker
	@queue = :subscription_timebomb_queue
	def self.perform(id)
		user = User.find(id)
		subscription_application = user.approved_subscription_application
		if user.sub_sus.count < ENV["TIMEBOMB_COUNT"].to_i || subscription_application != nil then
			#Not Successful
			#Email the user
			SubscriptionApplicationReviewMailer.fail_supporters(id).deliver	
			Resque.enqueue(UnsubscribeWorker,id,10)
			subscription_application.completion = false
			subscription_application.save		
			user.subscription_status_initial = nil
			user.save
		end
	end
end