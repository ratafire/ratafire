class TransactionWorker
	@queue = :transactions_queue
	def self.perform(id)
		transaction = Transaction.prefill!(:subscription_id => id)
		begin
			response = AmazonFlexPay.pay(transaction.amount, 'USD', transaction.SenderTokenId, transaction.uuid,
						:marketplace_variable_fee => transaction.ratafire, :recipient_token_id => transaction.RecipientTokenId)
			if response != nil then
				transaction.TransactionId = response.transaction_id
				transaction.save
				if transaction.TransactionId != nil then
					Resque.enqueue_at(1.minute.from_now, TransactionStatusWorker, transaction.TransactionId)
				else
					subscription = Subscription.find_by_id(transaction.subscription_id)
					if subscription.retry < 3 then 
						subscription = Subscription.find_by_id(transaction.subscription_id)
						Resque.enqueue_in(1.day,SubscriptionNowWorker,subscription.uuid)	
						SubscriptionMailer.failed_transaction_retry(transaction.id).deliver	
						subscription.retry += 1
						subscription.next_transaction_queued = false
						subscription.save
					else
						Resque.enqueue(UnsubscribeOneWorker, transaction.subscribed_id, transaction.subscriber_id, 3)
						SubscriptionMailer.auto_unsubscribe(transaction.id).deliver
					end					
				end
			else
				subscription = Subscription.find_by_id(transaction.subscription_id)
				if subscription.retry < 3 then 
					subscription = Subscription.find_by_id(transaction.subscription_id)
					Resque.enqueue_in(1.day,SubscriptionNowWorker,subscription.uuid)	
					SubscriptionMailer.failed_transaction_retry(transaction.id).deliver	
					subscription.retry += 1
					subscription.next_transaction_queued = false
					subscription.save
				else
					Resque.enqueue(UnsubscribeOneWorker, transaction.subscribed_id, transaction.subscriber_id, 3)
					SubscriptionMailer.auto_unsubscribe(transaction.id).deliver
				end
			end
		rescue AmazonFlexPay::API::Error => e
			#some notification
			if e != nil then
				transaction.error = e.to_s
				transaction.save
				subscription = Subscription.find_by_id(transaction.subscription_id)
				if subscription.retry < 3 then 
					Resque.enqueue_in(1.day,SubscriptionNowWorker,subscription.uuid)
					SubscriptionMailer.failed_transaction_retry(transaction.id).deliver	
					subscription.retry += 1
					subscription.next_transaction_queued = false
					subscription.save
				else
					Resque.enqueue(UnsubscribeOneWorker, transaction.subscribed_id, transaction.subscriber_id, 3)
					SubscriptionMailer.auto_unsubscribe(transaction.id).deliver
				end				
			end
		end
	end
end