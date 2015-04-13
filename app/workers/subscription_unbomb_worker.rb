class SubscriptionUnbombWorker
	@queue = :subscription_unbomb_queue
	def self.perform(id)
		user = User.find(id)
			#Successful
			#Email the user
			SubscriptionApplicationReviewMailer.success_supporters(id).deliver	
			subscription_application = user.approved_subscription_application
			subscription_application.completion = true
			subscription_application.save
	end
end