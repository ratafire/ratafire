class SubscriptionHistoryWorker
	include Sidekiq::Worker
	#could be retrying all the time, this has to be thread save

	def perform(subscription_id)

	end	
end