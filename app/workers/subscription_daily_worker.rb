class SubscriptionDailyWorker
	@queue = :subscriptions_daily_queue
	def self.perform()
		subscriptions = Subscription.where(:activated => true, :deleted_at => nil, :first_payment => true, :next_billing_date.to_date => Date.today)
		if subscriptions.count != 0 then
			subscriptions.each do |s|
				Resque.enqueue(TransactionWorker, s.id)
			end
		end
	end
end