class TransactionStatusWorker
	@queue = :transaction_status_queue

	def self.perform(transaction_id)
		transaction = Transaction.find_by_TransactionId(transaction_id)
		response = AmazonFlexPay.get_transaction(transaction_id)
		subscription = Subscription.find_by_id(transaction.subscription_id)
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
					transaction.next_transaction = subscription.next_billing_date
				else
					subscription.this_billing_date = subscription.next_billing_date
					subscription.next_billing_date = subscription.next_billing_date >> 1
					transaction.next_transaction = subscription.next_billing_date
				end
				#Update the status of last transaction
				last_transaction = Transaction.find_by_subscription_id_and_counter(subscription.id, subscription.counter)
				if last_transaction != nil then
					last_transaction.next_transaction_status = true
					last_transaction.save
				end				
				#Update Counter
				subscription.counter = subscription.counter+1
				subscription_record.counter = subscription_record.counter+1
				transaction.counter = subscription.counter	
				subscription.next_transaction_queued = true
				#Save all records				
				transaction.save
				subscription_record.save
				subscription.save			
				#Mailing the sucess confirmation email to the subscriber
				SubscriptionMailer.transaction_confirmation(transaction_id).deliver
				#Mailing the sucess confirmation email to the subscribed
				if subscription.counter == 1 && transaction.supporter_switch == false then 
					SubscriptionMailer.new_subscriber(transaction_id).deliver
				else
					SubscriptionMailer.transaction_confirmation_subscribed(transaction_id).deliver
				end
				#Enque the transaction for next month
				Resque.enqueue_in(1.month,SubscriptionNowWorker,subscription.uuid)								
			else
				#For failed transaction
				#Enqueue status worker again
				subscription.next_transaction_queued = false
				subscription.save
				if transaction.retry < 3 then
					Resque.enqueue_at(30.minute.from_now, TransactionStatusWorker, transaction.TransactionId)
					SubscriptionMailer.failed_transaction_retry(transaction_id).deliver	
					transaction.retry += 1
					transaction.save
				else
					Resque.enqueue(UnsubscribeOneWorker, transaction.subscribed_id, transaction.subscriber_id, 3)	
					SubscriptionMailer.auto_unsubscribe(transaction_id).deliver
				end
			end	
		else
			subscription.next_transaction_queued = false
			subscription.save			
			Resque.enqueue(UnsubscribeOneWorker, transaction.subscribed_id, transaction.subscriber_id, 3)
			SubscriptionMailer.auto_unsubscribe(transaction_id).deliver
		end
	end
end