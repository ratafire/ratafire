class ScheduledBillingWorker

	@queue = :scheduled_billing_queue

	def self.perform
		BillingSubscription.where(activated: true).all.each do |billing|
			
			@subscriber = User.find(billing.user_id)
			#Find the subscriber's subscriptions, and add up ordered amount
			@subscriber.subscriptions.each do |subscription|
				Subscription.create_transfer_and_order(subscription.id)
			end#@subscriber.subscriptions.each do |subscription|

			#Swipe the card for the ordered amount
			if @subscriber.order.amount != 0 then
				Order.transact_order(@subscriber.order.id,@subscriber.id)
			end#if @subscriber.order.amount != 0 then

		end#BillingSubscription.where(activated: true).all.each do |billing|
	end#self.perform

end#ScheduledBillingWorker