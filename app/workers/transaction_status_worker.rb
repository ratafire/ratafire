class TransactionStatusWorker
	@queue = :transaction_status_queue

	def self.perform(transaction_id)
		transaction = Transaction.find_by_TransactionId(transaction_id)
		response = AmazonFlexPay.get_transaction(transaction_id)
		if response != nil then
			transaction.status = response.transaction_status
			if transaction.status == "Success" then
				transaction.amazon = response.fps_fees.value.to_f.round(2)
				transaction.ratafire_fee = response.marketplace_fees.value.to_f.round(2)
				#Add to subscription record
				subscription_record = SubscriptionRecord.find(transaction.subscription_record_id)
				subscription_record.accumulated_total += response.transaction_amount.value.to_f.round(2)
					transaction.receive = response.transaction_amount.value.to_f.round(2) - transaction.amazon - transaction.ratafire_fee
					subscription_record.accumulated_amazon += transaction.amazon
					subscription_record.accumulated_ratafire += transaction.ratafire_fee
					subscription_record.accumulated_receive += transaction.receive	
				#Add to subscription
				subscription = subscription_record.subscriptions.first
				subscription.accumulated_total += response.transaction_amount.value.to_f.round(2)
				subscription.accumulated_amazon += transaction.amazon
				subscription.accumulated_ratafire += transaction.ratafire_fee
				subscription.accumulated_receive += transaction.receive				
				transaction.save
				subscription_record.save
				subscription.save
			else
				Resque.enqueue(UnsubscribeOneWorker, transaction.subscribed_id, transaction.subscriber_id, 3)		
			end	
		else
			Resque.enqueue(UnsubscribeOneWorker, transaction.subscribed_id, transaction.subscriber_id, 3)
		end
	end
end