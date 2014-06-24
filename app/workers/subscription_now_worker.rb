class SubscriptionNowWorker
	@queue = :subscription_now_queue
	def self.perform(uuid)
		subscription = Subscription.find_by_uuid(uuid)
		Resque.enqueue(TransactionWorker, subscription.id)
	end
end		