class TransactionStatusWorker
	@queue = :transaction_status_queue

	def self.perform(transaction_id)
		transaction = Transaction.find_by_TransactionId(transaction_id)
		response = AmazonFlexPay.get_transaction(transaction_id)
		if response != nil then
			transaction.status = response.transaction_status
			if transaction.status == "Success" then
				#For successful transaction
				transaction.amazon = response.fps_fees.value.to_f.round(2)
				transaction.ratafire_fee = response.marketplace_fees.value.to_f.round(2)
				#Add to subscription record
				subscription_record = SubscriptionRecord.find(transaction.subscription_record_id)
				subscription_record.accumulated_total += response.transaction_amount.value.to_f.round(2)
				transaction.receive = response.transaction_amount.value.to_f.round(2) - transaction.amazon - transaction.ratafire_fee
				subscription_record.accumulated_amazon += transaction.amazon
				subscription_record.accumulated_ratafire += transaction.ratafire_fee
				subscription_record.accumulated_receive += transaction.receive	
				subscription_record.accumulated = true
				#Add to subscription
				subscription = Subscription.find_by_id(transaction.subscription_id)
				subscription.accumulated_total += response.transaction_amount.value.to_f.round(2)
				subscription.accumulated_amazon += transaction.amazon
				subscription.accumulated_ratafire += transaction.ratafire_fee
				subscription.accumulated_receive += transaction.receive
				subscription.first_payment = true
				subscription.first_payment_created_at = Time.now
				#Update Billing Date
				if subscription.next_billing_date == nil then
					subscription.this_billing_date = Date.today
					subscription.next_billing_date = Date.today >> 1
				else
					subscription.this_billing_date = subscription.next_billing_date
					subscription.next_billing_date = subscription.next_billing_date >> 1
				end
				#Save all records				
				transaction.save
				subscription_record.save
				subscription.save
				#Mailing the sucess confirmation email
				SubscriptionMailer.transaction_confirmation(transaction_id).deliver
				Resque.enqueue_in(1.month,SubscriptionNowWorker,subscription.uuid)
			else
				#For failed transaction
				Resque.enqueue(UnsubscribeOneWorker, transaction.subscribed_id, transaction.subscriber_id, 3)		
			end	
		else
			Resque.enqueue(UnsubscribeOneWorker, transaction.subscribed_id, transaction.subscriber_id, 3)
		end
	end
end