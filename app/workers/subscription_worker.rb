class SubscriptionWorker
#	@queue = :subscriptions_queue
#	def self.perform()
#		subscriptions = Subscription.where(:activated => true, :deleted_at => nil)
#		if subscriptions.count != 0 then
#			subscriptions.each do |s|
#				Resque.enqueue(TransactionWorker, s.id)
#			end
#		end
#	end
end